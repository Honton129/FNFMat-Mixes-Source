@echo off
set "folder=.haxelib"
if not exist "%folder%" (mkdir "%folder%")
cd "%folder%"

@echo on
echo Installing the libraries to compile Friday Night Funkin'...
echo The duration of this process can variate depending on your internet speed.
haxelib git FlxPartialSound https://github.com/FunkinCrew/FlxPartialSound.git 41f35ddb1eb9d10bc742e6f8b5bcc62f9ef8ad84
haxelib git flixel https://github.com/FunkinCrew/flixel fffb1a74cf08f63dacc2ab09976340563f5b6e6d --skip-dependencies
haxelib git flixel-addons https://github.com/FunkinCrew/flixel-addons b9118f47f43a66bc0e5fbfcfd9903f0425e918ee
haxelib git flixel-text-input https://github.com/FunkinCrew/flixel-text-input 951a0103a17bfa55eed86703ce50b4fb0d7590bc
haxelib git flxanimate https://github.com/Dot-Stuff/flxanimate 713d3de0e566d6cd54cde13711ab3e4f60f59f4b
haxelib install format 3.5.0
haxelib git funkin.vis https://github.com/FunkinCrew/funkVis 1966f8fbbbc509ed90d4b520f3c49c084fc92fd6
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git 57f5d47f2533fd0c3dcd025a86cb86c0dfa0b6d2 src
haxelib install hamcrest 3.0.0
haxelib git haxeui-core https://github.com/haxeui/haxeui-core 74ba53387eab0c4c2d3825e103fe70df8e46d9b1
haxelib git haxeui-flixel https://github.com/haxeui/haxeui-flixel 34fe148e45292439a9c3caf00890c93bcc6f9453 --skip-dependencies
haxelib git hscript https://github.com/FunkinCrew/hscript 27c86f9a761c1d16d4433c4cf252eccb7b2e18de
haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp v4.3.75
haxelib git hxcpp-debug-server https://github.com/FunkinCrew/hxcpp-debugger 147294123f983e35f50a966741474438069a7a8f hxcpp-debug-server
haxelib git hxdiscord_rpc https://github.com/FunkinCrew/hxdiscord_rpc 82c47ecc1a454b7dd644e4fcac7e91155f176dec
haxelib git hxjsonast https://github.com/nadako/hxjsonast/ 20e72cc68c823496359775ac1f06500e67f189d5
haxelib install hxp 1.3.0
haxelib install hxvlc 2.0.1
haxelib git json2object https://github.com/FunkinCrew/json2object a8c26f18463c98da32f744c214fe02273e1823fa --skip-dependencies
haxelib git jsonpatch https://github.com/EliteMasterEric/jsonpatch f9b83215acd586dc28754b4ae7f69d4c06c3b4d3 --skip-dependencies
haxelib git jsonpath https://github.com/EliteMasterEric/jsonpath 7a24193717b36393458c15c0435bb7c4470ecdda
haxelib git mconsole https://github.com/massive-oss/mconsole 06c0499ed8f80628a0e6e55ffa32c3cbd688a838
haxelib git mcover https://github.com/massive-oss/mcover c3c47cd682b0b202a41caee95321989391b617ef src
haxelib git mockatoo https://github.com/FunkinCrew/mockatoo 13d77a0a8eaf5e789ef5dae6cd33eee812deda36 src
haxelib git munit https://github.com/FunkinCrew/MassiveUnit f61be7f7ba796595f45023ca65164a485aba0e7e src
haxelib git openfl https://github.com/FunkinCrew/openfl d061c936b462f040304ec2bd42d9f59d2e59e285
haxelib git polymod https://github.com/larsiusprime/polymod 0fbdf27fe124549730accd540cec8a183f8652c0
haxelib git thx.core https://github.com/fponticelli/thx.core 76d87418fadd92eb8e1b61f004cff27d656e53dd
haxelib git thx.semver https://github.com/fponticelli/thx.semver bdb191fe7cf745c02a980749906dbf22719e200b
haxelib git lime https://github.com/FunkinCrew/lime d1322e60f97b5c6e977f9e3e8a04f22b5190e7d9
echo Libraries installed succefully!
pause
