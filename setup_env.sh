#!/usr/bin/env bash

# =======================================================
# SL-GME Virtual Environment Setup
# =======================================================

set -e

VENV_DIR="venv"
PYTHON_MIN_VERSION="3.9"

echo "======================================================="
echo " Setting up Python environment for SL-GME"
echo "======================================================="

# -------------------------------------------------------
# Check Python availability
# -------------------------------------------------------
if ! command -v python3 >/dev/null 2>&1; then
  echo "❌ python3 not found. Please install Python ${PYTHON_MIN_VERSION}+."
  exit 1
fi

PYTHON_VERSION=$(python3 - << 'EOF'
import sys
print(".".join(map(str, sys.version_info[:3])))
EOF
)

echo "🐍 Detected Python version: $PYTHON_VERSION"

# -------------------------------------------------------
# Check Python version requirement
# -------------------------------------------------------
python3 - << EOF
import sys
min_version = tuple(map(int, "$PYTHON_MIN_VERSION".split(".")))
if sys.version_info < min_version:
    sys.exit("❌ Python $PYTHON_MIN_VERSION+ is required.")
EOF

# -------------------------------------------------------
# Create virtual environment (if missing)
# -------------------------------------------------------
if [ -d "$VENV_DIR" ]; then
  echo "📦 Virtual environment already exists: $VENV_DIR/"
else
  echo "📦 Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
fi

# -------------------------------------------------------
# Activate virtual environment
# -------------------------------------------------------
echo "⚡ Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# -------------------------------------------------------
# Upgrade pip + build tools
# -------------------------------------------------------
echo "⬆️  Upgrading pip and build tools..."
pip install --upgrade pip setuptools wheel

# -------------------------------------------------------
# Install dependencies
# -------------------------------------------------------
if [ -f "requirements.txt" ]; then
  echo "📥 Installing dependencies from requirements.txt..."
  pip install -r requirements.txt
else
  echo "❌ requirements.txt not found."
  exit 1
fi

# -------------------------------------------------------
# Install project in editable mode
# -------------------------------------------------------
echo "🔧 Installing SL-GME in editable (dev) mode..."
pip install -e .

# -------------------------------------------------------
# Done
# -------------------------------------------------------
echo ""
echo "======================================================="
echo " ✅ Environment setup complete"
echo "======================================================="
echo ""
echo "To activate later:"
echo "  source venv/bin/activate"
echo ""
echo "To run semantic analysis:"
echo "  python cli.py --corpus data/corpora/wikipedia_sample.txt \\"
echo "               --concepts data/concepts/atomic_concepts.json"
echo ""
