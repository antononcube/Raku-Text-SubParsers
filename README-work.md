# Text::SubParsers

Raku package for extracting and processing of interpret-able sub-strings in texts.

## Installation

From Zef ecosystem:

```
zef install Text::SubParsers
```

From GitHub:

```
zef install https://github.com/antononcube/Raku-Text-SubParsers.git
```

------

## Usage examples

Here we extract dates from a text:

```perl6
use Text::SubParsers;
my $res = "Openheimer's birthday is April 22, 1905 or April 2, 1905, as far as I know.";

Text::SubParsers::Core.new('DateTime').subparse($res).raku;
```

Compare with the result of the `parse` method over the same text:

```perl6
Text::SubParsers::Core.new('DateTime').parse($res);
```

Here are the results of both `subparse` and `parse` on string that is a valid date specification:

```perl6
Text::SubParsers::Core.new('DateTime').subparse('April 22, 1905');
```

```perl6
Text::SubParsers::Core.new('DateTime').parse('April 22, 1905');
```

------

## Processing LLM outputs

A primary motivation for creating this package is the processing the outputs of
Large Language Models (LLMs), [AA1, AAp1, AAp2, AAp3].

Here is an example of creating a LLM-function and its invocation over a string:

```perl6
use LLM::Functions;

my &fs = llm-function(
        {"What is the average speed of $_ ?"},
        llm-evaluator => llm-configuration(
                'PaLM',
                prompts => 'You are knowledgeable engineer and you give concise, numeric answers.'));

say &fs('car in USA highway');
```

Here is the corresponding interpretation using sub-parsers:

```perl6
Text::SubParsers::Core.new('Numeric').subparse(_.trim).raku;
```

------

## References

### Articles

[AA1] Anton Antonov,
["LLM::Functions"](https://rakuforprediction.wordpress.com/2023/07/21/llmfunctions/),
(2023),
[RakuForPrediction at WordPress](https://rakuforprediction.wordpress.com).

### Packages

[AAp1] Anton Antonov,
[LLM::Functions Raku package](https://github.com/antononcube/Raku-LLM-Functions),
(2023),
[GitHub/antononcube](https://github.com/antononcube).

[AAp2] Anton Antonov,
[WWW::OpenAI Raku package](https://github.com/antononcube/Raku-WWW-OpenAI),
(2023),
[GitHub/antononcube](https://github.com/antononcube).

[AAp3] Anton Antonov,
[WWW::PaLM Raku package](https://github.com/antononcube/Raku-WWW-PaLM),
(2023),
[GitHub/antononcube](https://github.com/antononcube).

