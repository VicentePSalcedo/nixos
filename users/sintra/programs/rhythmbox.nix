{ config, pkgs, ... }:

{
  # Extend GTK3 with Rhythmbox-specific TokyoNight CSS overrides
  # for a more cohesive look (sidebar, toolbar, track list, playback area)
  gtk.gtk3.extraCss = /* css */ ''
    /* ── Rhythmbox TokyoNight Storm refinements ── */

    /* Main window: use TokyoNight storm background */
    window.background.org-gnome-Rhythmbox3 {
      background-color: #1a1b26;
    }

    window.background.org-gnome-Rhythmbox3 .titlebar {
      background-color: #1a1b26;
      background-image: none;
      border-bottom: 1px solid #292e42;
    }

    window.background.org-gnome-Rhythmbox3 .titlebar button {
      background-color: #24283b;
      color: #c0caf5;
      border: 1px solid #292e42;
    }

    window.background.org-gnome-Rhythmbox3 .titlebar button:hover {
      background-color: #292e42;
    }

    window.background.org-gnome-Rhythmbox3 .titlebar label {
      color: #c0caf5;
    }

    /* Sidebar — Source List (pane with library, playlists, etc.) */
    window.background.org-gnome-Rhythmbox3 .sidebar,
    window.background.org-gnome-Rhythmbox3 .sidebar-pane {
      background-color: #1a1b26;
      color: #a9b1d6;
      border-right: 1px solid #292e42;
    }

    window.background.org-gnome-Rhythmbox3 .sidebar row:selected {
      background-color: #24283b;
      color: #7aa2f7;
    }

    window.background.org-gnome-Rhythmbox3 .sidebar row:hover {
      background-color: #292e42;
    }

    /* Expand / collapse arrows in source list */
    window.background.org-gnome-Rhythmbox3 .sidebar arrow {
      color: #565f89;
    }

    /* Track list / main content area */
    window.background.org-gnome-Rhythmbox3 treeview.view {
      background-color: #24283b;
      color: #c0caf5;
    }

    window.background.org-gnome-Rhythmbox3 treeview.view:selected {
      background-color: #292e42;
      color: #7aa2f7;
    }

    window.background.org-gnome-Rhythmbox3 treeview.view:selected:focus {
      background-color: #292e42;
      color: #7aa2f7;
    }

    window.background.org-gnome-Rhythmbox3 treeview.view:hover {
      background-color: #1a1b26;
    }

    /* Column headers in track list */
    window.background.org-gnome-Rhythmbox3 treeview.view header button {
      background-color: #1a1b26;
      color: #a9b1d6;
      border-bottom: 1px solid #292e42;
    }

    /* Playback toolbar at the bottom */
    window.background.org-gnome-Rhythmbox3 .playback-toolbar,
    window.background.org-gnome-Rhythmbox3 .rhythmbox-play-toolbar {
      background-color: #1a1b26;
      border-top: 1px solid #292e42;
      color: #c0caf5;
    }

    window.background.org-gnome-Rhythmbox3 .playback-toolbar button,
    window.background.org-gnome-Rhythmbox3 .rhythmbox-play-toolbar button {
      background-color: transparent;
      color: #c0caf5;
      border: none;
    }

    window.background.org-gnome-Rhythmbox3 .playback-toolbar button:hover,
    window.background.org-gnome-Rhythmbox3 .rhythmbox-play-toolbar button:hover {
      background-color: #292e42;
      color: #7aa2f7;
    }

    /* Volume slider */
    window.background.org-gnome-Rhythmbox3 scale trough {
      background-color: #292e42;
      border: 1px solid #414868;
    }

    window.background.org-gnome-Rhythmbox3 scale trough highlight {
      background-color: #7aa2f7;
    }

    window.background.org-gnome-Rhythmbox3 scale slider {
      background-color: #7aa2f7;
      border: none;
    }

    /* Status bar */
    window.background.org-gnome-Rhythmbox3 .statusbar {
      background-color: #1a1b26;
      color: #565f89;
      border-top: 1px solid #292e42;
    }

    /* Search entry */
    window.background.org-gnome-Rhythmbox3 entry {
      background-color: #24283b;
      color: #c0caf5;
      border: 1px solid #414868;
    }

    window.background.org-gnome-Rhythmbox3 entry:focus {
      border-color: #7aa2f7;
    }

    /* Dialogs */
    window.background.org-gnome-Rhythmbox3 dialog {
      background-color: #1a1b26;
      color: #c0caf5;
    }

    window.background.org-gnome-Rhythmbox3 dialog .titlebar {
      background-color: #1a1b26;
    }

    /* Menus and popovers */
    window.background.org-gnome-Rhythmbox3 menu,
    window.background.org-gnome-Rhythmbox3 .menu {
      background-color: #24283b;
      color: #c0caf5;
      border: 1px solid #414868;
    }

    window.background.org-gnome-Rhythmbox3 menu menuitem:hover,
    window.background.org-gnome-Rhythmbox3 .menu menuitem:hover {
      background-color: #292e42;
    }

    /* Notebook / tab bar */
    window.background.org-gnome-Rhythmbox3 notebook {
      background-color: #24283b;
    }

    window.background.org-gnome-Rhythmbox3 notebook tab {
      background-color: #1a1b26;
      color: #a9b1d6;
    }

    window.background.org-gnome-Rhythmbox3 notebook tab:selected {
      background-color: #24283b;
      color: #7aa2f7;
    }

    /* Scrollbars */
    window.background.org-gnome-Rhythmbox3 scrollbar {
      background-color: #1a1b26;
    }

    window.background.org-gnome-Rhythmbox3 scrollbar slider {
      background-color: #414868;
      border-radius: 4px;
    }

    window.background.org-gnome-Rhythmbox3 scrollbar slider:hover {
      background-color: #565f89;
    }

    /* Tooltips */
    window.background.org-gnome-Rhythmbox3 tooltip {
      background-color: #24283b;
      color: #c0caf5;
      border: 1px solid #414868;
    }

    /* Progress bars (e.g. playback progress) */
    window.background.org-gnome-Rhythmbox3 progressbar trough {
      background-color: #292e42;
      border: 1px solid #414868;
    }

    window.background.org-gnome-Rhythmbox3 progressbar progress {
      background-color: #7aa2f7;
    }

    /* Paned separator */
    window.background.org-gnome-Rhythmbox3 paned separator {
      background-color: #292e42;
    }
  '';
}
