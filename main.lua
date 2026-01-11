local WidgetContainer = require("ui/widget/container/widgetcontainer")
local UIManager = require("ui/uimanager")
local logger = require("logger")
local ffi = require("ffi")

-- C Definitions for File System Operations
ffi.cdef[[
    typedef struct { uint32_t d_ino; uint32_t d_off; uint16_t d_reclen; uint8_t d_type; char d_name[256]; } dirent_t;
    void* opendir(const char *name);
    dirent_t* readdir(void *dirp);
    int closedir(void *dirp);
    int mkdir(const char *pathname, uint32_t mode);
    int rename(const char *oldpath, const char *newpath);
    int access(const char *path, int amode);
]]

local ScreenshotOrganizer = WidgetContainer:extend{
    name = "screenshotorganizer",
}

-- Clean up the screenshot name into a readable folder title
function ScreenshotOrganizer:getPrettyTitle(filename)
    local name = filename:gsub("^Reader_", "")
    
    -- Strip common ebook extensions and anything following (timestamps/pages)
    name = name:gsub("%.%w+.*$", "")
    
    -- Remove trailing metadata in parentheses (e.g., "(79)", "(v1)")
    name = name:gsub("%s?%(.-%)%s*$", "")
    
    -- Replace underscores/dashes with spaces and trim
    name = name:gsub("[_%-]", " "):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
    
    return name ~= "" and name or "Other"
end

function ScreenshotOrganizer:processDirectory(path)
    if ffi.C.access(path, 0) ~= 0 then return end
    
    local dir = ffi.C.opendir(path)
    if dir == nil then return end

    while true do
        local entry = ffi.C.readdir(dir)
        if entry == nil then break end
        
        local name = ffi.string(entry.d_name)
        -- Process only PNG files and ignore those already in subfolders
        if name:match("%.png$") then
            local folderName = self:getPrettyTitle(name)
            local targetDir = path .. "/" .. folderName
            
            -- Ensure target directory exists
            if ffi.C.access(targetDir, 0) ~= 0 then
                ffi.C.mkdir(targetDir, 511) -- 0777 permissions
            end
            
            local oldPath = path .. "/" .. name
            local newPath = targetDir .. "/" .. name
            
            if ffi.C.rename(oldPath, newPath) == 0 then
                logger.info("ScreenshotOrganizer: Organized -> " .. folderName)
            end
        end
    end
    ffi.C.closedir(dir)
end

function ScreenshotOrganizer:organize()
    -- Scan all likely Kindle mount points
    local locations = {
        "/mnt/us/koreader/screenshots",
        "/mnt/base-us/koreader/screenshots",
        "/mnt/us/screenshots"
    }

    for _, root in ipairs(locations) do
        self:processDirectory(root)
    end
end

function ScreenshotOrganizer:init()
    -- Only log once on startup to verify the plugin is active
    logger.info("ScreenshotOrganizer: Plugin Initialized (Pretty-Name Scraper)")
    self:run()
end

function ScreenshotOrganizer:run()
    self:organize()
    -- Re-schedule the next run in 10 seconds
    UIManager:scheduleIn(10, function() self:run() end)
end

return ScreenshotOrganizer