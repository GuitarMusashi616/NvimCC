function url(file, branch, repo)
    branch = branch or "master"
    repo = repo or "NvimCC"
    return ("https://raw.githubusercontent.com/GuitarMusashi616/%s/%s/%s"):format(repo, branch, file)
end

local libs = {"class.lua", "tbl.lua", "util.lua"}
local mains = {"model.lua", "view.lua", "controller.lua", "hjkl.lua", "nvim.lua", "insert_mode.lua"}

function dl(files, folder)
    local folder = folder or ""
    for _, file in pairs(files) do
        file = folder..file
        if fs.exists(file) then
            shell.run("rm "..file)
        end
        shell.run("wget "..url(file))
    end
end

if fs.exists("lib") then
    shell.run("rm lib")
end

shell.run("mkdir lib")
shell.run("cd lib")

dl(libs, "lib/")

shell.run("cd ..")

dl(mains)