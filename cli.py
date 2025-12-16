#!/usr/bin/env python3
"""
SL-GME Command Line Interface
"""

import argparse
import sys
from pathlib import Path

# Add src to path
sys.path.insert(0, str(Path(__file__).parent / "src"))

def main():
    parser = argparse.ArgumentParser(
        description="SL-GME: Semantic-Load-Guided Model Evolution",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  slgme analyze --corpus data/corpora/sample.txt --concepts data/concepts/atomic.json
  slgme compress --model gpt2 --output bootloader.slime
  slgme evolve --bootloader model.slime --teacher improved_model
"""
    )

    subparsers = parser.add_subparsers(dest="command", help="Command to execute")

    # Analyze command
    analyze_parser = subparsers.add_parser("analyze", help="Calculate semantic load")
    analyze_parser.add_argument("--corpus", required=True, help="Path to corpus file")
    analyze_parser.add_argument("--concepts", required=True, help="Path to concepts file")
    analyze_parser.add_argument("--output", default="results/lambda_values.json",
                              help="Output file path")

    # Compress command
    compress_parser = subparsers.add_parser("compress", help="Create bootloader")
    compress_parser.add_argument("--model", required=True, help="Model name or path")
    compress_parser.add_argument("--corpus", help="Corpus for semantic analysis")
    compress_parser.add_argument("--output", required=True, help="Output bootloader path")
    compress_parser.add_argument("--threshold", type=float, default=0.0,
                               help="Semantic load threshold")

    # Evolve command
    evolve_parser = subparsers.add_parser("evolve", help="Run guided evolution")
    evolve_parser.add_argument("--bootloader", required=True, help="Input bootloader")
    evolve_parser.add_argument("--teacher", required=True, help="Teacher model")
    evolve_parser.add_argument("--steps", type=int, default=1000,
                             help="Number of evolution steps")
    evolve_parser.add_argument("--output", required=True, help="Output model path")

    args = parser.parse_args()

    if args.command == "analyze":
        from semantic_load.calculator import SemanticLoadCalculator
        calculator = SemanticLoadCalculator()
        lambda_values = calculator.analyze(args.corpus, args.concepts)
        calculator.save_results(lambda_values, args.output)
        print(f"✅ Analysis saved to {args.output}")

    elif args.command == "compress":
        print("⚠️ Compression module not yet implemented")
        print(f"Would compress {args.model} to {args.output}")

    elif args.command == "evolve":
        print("⚠️ Evolution module not yet implemented")
        print(f"Would evolve {args.bootloader} using {args.teacher}")

    else:
        parser.print_help()

if __name__ == "__main__":
    main()
