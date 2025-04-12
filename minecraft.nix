{ pkgs, ...}:
{
	services.tailscale.enable = true;

	systemd.services.tailscale-autoconnect = {
		description = "Automatic connection to Tailscale";
		after = [ "network-pre.target" "tailscale.service" ];
		wants = [ "network-pre.target" "tailscale.service" ];
		wantedBy = [ "multi-user.target" ];

		serviceConfig.Type = "oneshot";
	};
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ 25565 25575 ];  
		allowedUDPPorts = [ 25565 ];
	};
	services.minecraft-server = {
		enable = true;
		eula = true;
		declarative = true;

		package = pkgs.minecraft-server;
		dataDir = "/var/lib/minecraft";
		serverProperties = {
			server-ip = "0.0.0.0";
			gamemode = "survival";
			difficulty = "normal";
			simulation-distance = 4;
			view-distance = 6;
			level-sedd = "4";
			max-tick-time = 15000;
			rcon-enable = true;
			"rcon.password" = "hello";
			"rcon.port" = 25575;
			max-players = 5;
			motd = "NixOS Minecraft server!";
			#white-list = true;
		};
		whitelist = {
			Mineur34 = "1aecfedc-3b42-43de-9601-1dbdc917159d";
			Kix300 = "c8e8e83a-36e9-4dab-8f09-10ec6cd101c2";
		};
		jvmOpts = "-Xms3G -Xmx3G -XX:+UseG1GC";
	};
}
