import matplotlib.pyplot as plt

# These values were extracted by hand from the evaluation_terminal_output.txt
beam_sizes = [1, 2, 3, 4, 5, 7, 10, 15, 20, 25]
bleu_scores = [9.00, 11.52, 11.13, 10.96, 10.71, 10.51, 10.02, 9.41, 9.02, 8.78]
times = [25, 20, 25, 27, 33, 44, 60, 99, 146, 183]  # replace with your real numbers

# BLEU Score vs Beam Size
plt.figure()
plt.plot(beam_sizes, bleu_scores, marker='o')
plt.title("BLEU Score vs Beam Size")
plt.xlabel("Beam Size")
plt.ylabel("BLEU Score")
plt.grid(True)
plt.tight_layout()
plt.show()

# Time vs Beam Size
plt.figure()
plt.plot(beam_sizes, times, marker='o')
plt.title("Time Taken vs Beam Size")
plt.xlabel("Beam Size")
plt.ylabel("Time (s)")
plt.grid(True)
plt.tight_layout()
plt.show()
