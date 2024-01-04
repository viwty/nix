{ pkgs, ... }: {
  home.packages = with pkgs; [
    neofetch
    wireplumber
    ncmpcpp
    yt-dlp
    ffmpeg-full
    vesktop
    btop
    killall
    ripgrep
    yue
    imagemagick
    mpv
    wf-recorder
    prismlauncher
    pcmanfm
    bitwarden
    gimp
    steam
    qpwgraph
    protontricks
    fzf
    virt-manager
    gnome.gnome-calculator
    wine64
    p7zip
    craftos-pc
    pavucontrol
    ffmpegthumbnailer
    nixfmt
    qbittorrent
    telegram-desktop
    man-pages
    sccache
    picard
    mate.engrampa
    cached-nix-shell
    rustup
    gcc
    # why nix, why?
    (luajit.withPackages (p: with p; [fennel readline luafilesystem]))
    fennel-ls
    fnlfmt
    mindustry-wayland
    blockbench-electron
  ];
}
