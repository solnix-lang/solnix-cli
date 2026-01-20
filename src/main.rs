use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    Build {
        input: String,
        #[arg(short, long)]
        output: String,
        #[arg(long)]
        release: bool,
    },
    Run {
        input: String,
        #[arg(short, long)]
        iface: Option<String>,
    },
    Check {
        input: String,
    },
    Version,
}

fn main() {
    let cli = Cli::parse();

    match cli.command {
        Some(Commands::Build { input, output, release }) => {
            println!("Compiling {} -> {} (release: {})", input, output, release);
        }
        Some(Commands::Run { input, iface }) => {
            println!("Running {} on {:?}", input, iface);
        }
        Some(Commands::Check { input }) => {
            println!("Checking {}", input);
        }
        Some(Commands::Version) => {
            println!("Solnix Compiler v0.1.0");
        }
        None => {
            println!("\x1b[1;34m============================================\x1b[0m");
            println!("\x1b[1;32m       Solnix Compiler  v0.1.0\x1b[0m");
            println!("\x1b[1;34m============================================\x1b[0m\n");
            println!("Usage: solnix <command> [flags] <file>\n");
            println!("Commands:");
            println!("  build      Compile .snx to eBPF ELF object");
            println!("  run        Compile and attach program to interface");
            println!("  check      Syntax/type checking only");
            println!("  version    Show compiler version");
            println!("  help       Show this help message\n");
            println!("Example:");
            println!("  solnix build examples/xdp_counter.snx -o output.o\n");
        }
    }
}
