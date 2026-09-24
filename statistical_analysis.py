# ============================================================
# Project: Simple Statistical Analyzer
# Author: Uranus Kamali
# Tag: Uranus Kamali
# ============================================================

import statistics


def analyze_data(data):
    """Calculate basic statistical values for a dataset."""

    if not data:
        return None

    result = {
        "count": len(data),
        "mean": statistics.mean(data),
        "median": statistics.median(data),
        "minimum": min(data),
        "maximum": max(data),
        "standard_deviation": statistics.stdev(data)
        if len(data) > 1 else 0
    }

    return result


# Uranus Kamali - Sample Python Project

numbers = [12, 18, 15, 22, 17, 25, 19, 14, 21, 16]

results = analyze_data(numbers)

print("================================")
print("   Statistical Analysis")
print("   Uranus Kamali")
print("================================")

for key, value in results.items():
    if isinstance(value, float):
        print(f"{key}: {value:.2f}")
    else:
        print(f"{key}: {value}")
