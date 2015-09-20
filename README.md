# elbot

elbot is a chat bot on [soozy](https://soozy.slack.com/).

## Setup and Run

```
% sudo docker build -t `whoami`/elbot .
% sudo docker run -e HUBOT_SLACK_TOKEN=your_token --name elbot `whoami`/elbot
```

## Commands

#### Evaluation

```
> elbot eval s-expression
```

#### Show document

```
> elbot doc function or variable
```


## Specification

1. Get s-expression from Slack
2. Launches `emacs --daemon=id` and wait until `emacs --daemon` starts
3. Laucnhes `emacsclient -s id -e s-expression` for evaluating s-expression
4. Gets result of s-expression ands send response to Slack
5. kill `emacs --daemon` for avoiding evaluating infinite loop s-expression
6. Wait for next s-expression
