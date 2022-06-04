function url(file, branch, repo)
    branch = branch or "master"
    repo = repo or "NvimCC"
    return ("https://raw.githubusercontent.com/GuitarMusashi616/%s/%s/%s"):format(repo, branch, file)
end

local files = {"lib/class.lua", "model.lua", "view.lua", "controller.lua", "hjkl.lua", "nvim.lua"}

for _, file in pairs(files) do
    if fs.exists(file) then
        shell.run("rm "..file)
    end
    shell.run("wget "..url(file))
end