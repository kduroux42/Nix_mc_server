{ config, pkgs, lib, ... }:

{
	imports = [
		"${fetchTarball "https://github.com/NixOS/nixos-hardware/tarball/master"}/raspberry-pi/4"
		./minecraft.nix
	];
	boot = {
		kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
		initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
		loader = {
			grub.enable = false;
			generic-extlinux-compatible.enable = true;
		};
	};
	nixpkgs.config.allowUnfree = true;

	fileSystems = {
		"/" = {
			device = "/dev/disk/by-label/NIXOS_SD";
			fsType = "ext4";
			options = [ "noatime" ];
		};
	};

	networking = {
		hostName = "mc-server";
	};

	environment.systemPackages = with pkgs; [
		vim
			neovim
			fish
			git
			rcon
			libraspberrypi
	];

	services.openssh.enable = true;
	services.openssh.permitRootLogin = "no";

	users.users.steve = {
		isNormalUser = true;
		description = "steve";
		extraGroups = ["wheel"];
		packages = with pkgs; [
			vim
		];
	};

	hardware.enableRedistributableFirmware = true;
	system.stateVersion = "23.11";
}
