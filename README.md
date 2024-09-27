## Setup

First, install the starter template in a new directory:

```
mkdir -p nixos-config && cd nixos-config && nix flake --extra-experimental-features 'nix-command flakes' init -t github:dustinlyons/nixos-config#starter
```

Apply command will update the template with the inputs, mostly for git config:

```
nix run .#apply
```

Build will install and compile the various packages specified:

```
nix run .#build
```

Finally, when ready to update your computer with config you just built, run the build-switch command. You will need to enable both flakes and nix-command. As I understand, they are experimental features that the nix community is converging on, but are not standardized yet.

```
nix run --extra-experimental-features 'nix-command flakes' .#build-switch
```

### Manual installation

Currently, I have installed the following packages manually. Eventually, I will tweak the starter config to include them automatically.

```
  nix profile install nixpkgs#elixir_1_17
  nix proflie install nixpkgs#erlang_25
  nix profile install nixpkgs#rustup
  nix profile install nixpkgs#rustc
  nix profile install nixpkgs#postgresql_16
  nix profile install nixpkgs#rectangle
  nix profile install nixpkgs#maccy
```

### Postgres Installation

After installing the postgres package, we'll want to make sure it runs each time the computer starts. First, we'll need to initialize the database:

```
export DB_DATA='/Users/ryancurtin/src/postgres/data'
initdb -D $DB_DATA
```

Now that postgres has been initialized in the directory of your choosing, we'll need to create a Launch Config to run via `launchctl`. Copy the provided wrapper script in `scripts/postgres-wrapper.sh` to your `$DB_DATA` directory, and then copy the `launchctl/org.postgresql.plist` launch config to the appropriate directory:

```
cp scripts/postgres-wrapper.sh $DB_DATA/postgres-wrapper.sh
cp launchctl/org.postgresql.plist ~/Library/LaunchAgents/org.postgresql.plist
```

Once all of your files are in place, we'll need to load the config and attempt to start the service:

```
launchctl load ~/Library/LaunchAgents/org.postgresql.plist
launchctl start org.postgresql
```

If that was successful, you'll see postgres running, and you should be able to connect once the proper role is created:

```
createuser -s postgres
psql
```

Once in the console, you should be able to run postgres commands! If you want to run postgres each time the computer starts, open `System Settings > General > Login Items` and add your `org.postgresql.plist` file to the list. You may need to add that directory to the left-hand bar if you are performing this change in Finder.

### Upgrading Nix Packages / Channels

To upgrade a specific version of a package, you can specify an override manually:

```
(chromedriver.overrideAttrs (oldAttrs: rec {
    version = "129.0.6668.58";
  }))
```

This may or may not work, depending on the nix channel you have available. You can upgrade your nix channel as follows:

```
nix-channel --add https://channels.nixos.org/nixpkgs-24.05-darwin nixpkgs
nix-channel --update
```

After that completes, you should have an upgrade source of packages available. Next time you build, you should be able to upgrade accordingly:

```
nix run .#build
nix run .#build-switch
```

There is also a command to upgrade a package manually (specify '\*' to upgrade all packages):

```
nix-env -u chromedriver
```

You may also want to run cleanup to free some space:

```
nix-collect-garbage
```
