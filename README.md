This exercise was solved by Marc Amsler (marctfamsler, 22-726-206) and Nicolas Burgener (niburg, 23-718-927).

# Exercise 1:

To preprocess (subsample 100k sentences and tokenize on word level) the data we used the script preprocess.py:

    ./scripts/preprocess.sh

To learn a BPE model, we used the scripts in the scripts/learn_bpe folder.

Finally, we created a separate config and training script file to train each model:

  ./scripts/train_word_level.sh
  ./scripts/train_bpe_2k.sh
  ./scripts/train_bpe_5k.sh

We trained a model that used a word-level tokenizer and a model that used BPE-Tokenization with a vocabulary size of 2000. We then wanted to see how much of a positive impact on translation quality a larger vocabulary has and trained the third model using BPE-Tokenization with a vocabulary size of 5000. These are the results:


|       |  use BPE  | vocabulary size | BLEU |
|:------|:---------:|----------------:|-----:|
| (a)   | no        | 2000            | 8.5  |
| (b)   | yes       | 2000            | 8.9  |
| (c)   | yes       | 5000            | 10.7 |

According to the bleu score results, the model that used BPE tokenization with a vocab size of 5k was the best. This is also our opinion after taking a closer look at the translations themselves.

We can only speak a little bit of italian, so our conclusions are only based on this little bit of language knowledge and the comparisons to the reference translations.

In general, the word_level model produced a lot of <unk> tokens. We expected this, because we only used a vocabulary size of 2k and if we have rather uncommon words appearing in the test data, the model doesn't know them and produces an <unk> token. In total, the word_level model produced 6161 <unk> tokens. The models that use BPE tokenization also have some <unk> tokens, but a lot less. The bpe_2k model produced 783 <unk> tokens while translating the test data, the bpe_5k model produced 949 <unk> tokens. So for both BPE models, we reduced the amount of generated <unk> tokens by at least 6 times.
We don't know however, how the BPE model with a vocabulary of 2k produced less <unk> tokens than the one with a vocabulary of 5k. According to the logic of the BPE-algorithm, this should be the other way around and we can't explain how this happened.

Example: Less often occuring words, like „marshmallow“ were translated correctly by both BPE models, while the word level model just produced an <unk> token. This aligns with our expectations, since "marshmallow" probably didn't make it into the word_level vocabulary, while it could be reconstructed from subword tokens in the translations from models that used BPE tokenization. 

For the following analysis, we used ChatGPT, as well as our own limited knowledge of the italian language.

Word-level model: The translation quality is very bad. While the BLEU score is still comparable to the bpe_2k model, the translations aren't very fluent, sometimes incomplete and the amount of <unk> tokens make them nearly impossible to be of use. However, ChatGPT says that the model managed to generate a few small fragments of correct syntax. In our opinion, the BLEU score of this model is not meaningful, because the <unk> tokens don't influence the BLEU score too much, but they hurt the translation quality a lot.

Bpe-2k model: While these translations have a similar bleu-score to the word-level model predictions, the translations are of a far better quality (ChatGPT also backs this up). There are far fewer <unk> tokens and in our humble opinion, the translations seem understandable. ChatGPT says that the grammar and syntax of the translations are better. The model creates some fluent and correct phrases, which also have a correct sentence structure. However, there is still repetition and hallucination, with some incorrect grammar in the translations. Overall, the translation quality is still not very good, but it is far better than the word-level model. 

Bpe-5k model: These predictions have the best BLEU score out of the three models. In our opinion, they look pretty similar to the bpe-2k model predictions. There are a few minor differences in word-choice and sentence structure, but due to our limited knowledge of italian we can't really say which one is better. ChatGPT however says that this is the best of the three models, with mostly fluent sentences, better grammar and less repetition. The model is still not perfect though, with it still generating a few odd expressions. 

So in general, our expectations were met and while a model using BPE Tokenization produced better translations than a model using word-level tokenization, a vocabulary size of 2000 was too small and the translation quality improved by increasing the vocabulary size to 5000.


# Exercise 2:
We had a lot of trouble with generating the translations using different beam sizes, because we didn't see the evaluate.sh script in the scripts folder untill the very end and tried to write our own script. In the end, we printed the evaluation scores and times to the terminal and copied the terminal output to thebeam_eval_results/evaluation_terminal_output.txt file. From there, we extracted the values by hand and wrote them to the python file which generated the plots.

We ran the test evaluations with different beam sizes by running:

  ./scripts/evaluate_beam_sizes.sh

This script calls 10 different config files from the configs/configs_beam_size folder (which each have different beam sizes) and prints the time taken and BLEU score to the terminal.

To plot the values, run from the beam_eval_results folder:

  python beam_search_evaluation.py

![bleu_scores](https://github.com/user-attachments/assets/7756a163-68a8-4234-a8e7-2fa2eca2f414)
![time_taken](https://github.com/user-attachments/assets/17b7b667-5bfb-48b8-bf3d-5f514d4e7bef)

The BLEU-Score for a beam-size of 1 is not that good in comparison to the others, because it's greedy decoding. The impact of making the beam size to 2 is huge, and this beam size leads to the best BLEU scores. In addition to this, the time taken for decoding is also the lowest at a beam size of 2. We were a bit surprised that beam sizes of 3, 4 and 5 gradually got a lower BLEU score, since we initially thought that one of those beam sizes would lead to the best score. From there on, the quality of translations further decreased with a higher beam size. At a beam size of 20, we get a similar BLEU score to a beam size of one and increasing the beam size even further just decreases translation quality even more. The time taken for decoding also increases linearly with a higher beam size, so there were no surprises there.




# MT Exercise 4: Byte Pair Encoding, Beam Search

This repository is a starting point for the 4th and final exercise. As before, fork this repo to your own account and then clone it into your preferred directory.

---

## Requirements

- Python 3.10 must be installed. The command `python3` (or `python` on Windows) should be available from your terminal or command prompt.
- `virtualenv` must be installed. Install it with:

  ```bash
  pip install virtualenv

macOS/Linux users: No special setup needed; shell scripts should run normally.

Windows users: Either use Windows Subsystem for Linux (WSL) or a Unix-compatible shell like Git Bash.
If you're using PowerShell or Command Prompt, manual setup is required.

### Setup Instructions

## For macOS / Linux / WSL / Git Bash users

Clone your fork of the repository + Create a virtual environment:
   ```
   git clone https://github.com/[your-username]/mt-exercise-4
   cd mt-exercise-4 

   ```
    ./scripts/make_virtualenv.sh

Important: Then activate the env by executing the source command that is output by the shell script above.

Install required dependencies - Follow the instructions provided in the exercise PDF.

Download data:

    ./download_iwslt_2017_data.sh


Train the model:

       ./scripts/train.sh

*the training process can be interrupted at any time. The best checkpoint will always be saved automatically.

Evaluate the model:

       ./scripts/evaluate.sh

## For Windows (Command Prompt / PowerShell users)
Manually create and activate a virtual environment:

        python -m venv mt_env
        mt_env\Scripts\activate

Note: The make_virtualenv.sh script will not work in native Windows shells.

Manually download the dataset

Open the download_iwslt_2017_data.sh file in a text editor and run the commands one-by-one in your shell.
Alternatively, use Git Bash or WSL to run it directly.

Modify, train, and evaluate
Once setup is complete, use the instructions in the exercise PDF to run training and evaluation (either by adapting the .sh scripts manually, or by using Git Bash/WSL).

#### Notes for Windows Users

  Using Git Bash or WSL is highly recommended for compatibility.

  If using native PowerShell or Command Prompt:

  Manual recreation of shell script steps will be necessary.

  Always activate your virtual environment before running any training or evaluation steps.

