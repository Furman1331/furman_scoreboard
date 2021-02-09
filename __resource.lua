resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
shared_script '@CentrumRP/lib/centrum.lua'

client_script 'client.lua'
server_scripts {
	'@async/async.lua',
	'server.lua'
}

ui_page 'html/scoreboard.html'
files {
    'html/scoreboard.html',
    'html/style.css',
    'html/reset.css',
    'html/listener.js',
    'html/img.png',
    'html/logo.png'
}