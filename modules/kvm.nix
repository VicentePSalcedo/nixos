{ pkgs, ... }:
{
  boot.extraModprobeConfig = "options kvm_intel nested=1";
    environment.systemPackages = with pkgs; [ 
    qemu 
    libvirt 
    virt-manager 
    virt-viewer 
    spice 
    spice-gtk 
    spice-protocol 
    win-virtio 
    win-spice 
    adwaita-icon-theme 
  ];
}
