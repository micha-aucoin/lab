#!/usr/bin/env python

import os
import subprocess
import sys
from enum import Enum
from pathlib import Path


class BuiltIns:
    def exit(self, args: list[str]) -> None:
        sys.exit(0)

    def echo(self, args: list[str]) -> None:
        print(" ".join(args))

    def pwd(self, args: list[str]) -> None:
        print(Path.cwd())

    def cd(self, args: list[str]) -> None:
        if not args:
            return

        target_dir = args[0]
        if not Path(target_dir).is_dir():
            print(f"cd: {target_dir}: No such file or directory")
            return

        os.chdir(target_dir)

    def type(self, args: list[str]) -> None:
        name = args[0]

        # check builtins
        builtin_func = getattr(self, name, None)
        if callable(builtin_func):
            print(f"{name} is a shell builtin")
            return

        # check PATH
        paths = os.environ.get("PATH", "").split(os.pathsep)
        for path in paths:
            file_path = Path(path) / name
            if file_path.is_file() and os.access(file_path, os.X_OK):
                print(f"{name} is {file_path}")
                return

        print(f"{name}: not found")


class TokenState(Enum):
    DEFAULT = 0
    IN_SINGLE_QUOTE = 1
    IN_DOUBLE_QUOTE = 2
    DEFAULT_BACKSLASH = 3
    BACKSLASH_IN_DOUBLE_QUOTE = 4


class Shell:
    def __init__(self):
        self.built_ins: BuiltIns = BuiltIns()
        self.command: str = ""
        self.args: list[str] = []

    def parse(self, line: str) -> bool:
        tokens = self._tokenizer(line=line)
        if not tokens:
            return False
        self.command = tokens[0]
        self.args = tokens[1:]
        return True

    def _tokenizer(self, line: str) -> list[str]:
        staging_tokens: list[str] = []
        final_tokens: list[str] = []

        state: TokenState = TokenState.DEFAULT
        home: str = os.environ.get("HOME", "")

        for char in line:
            # breakpoint() # uncomment for debuggin
            match state:
                case TokenState.DEFAULT:
                    match char:
                        case " " if staging_tokens:
                            # end of token
                            final_tokens.append("".join(staging_tokens))
                            staging_tokens = []
                        case " ":
                            # ignore spaces with no current tokens
                            pass
                        case "'":
                            # enter single quote state
                            state = TokenState.IN_SINGLE_QUOTE
                        case '"':
                            # enter double quote state
                            state = TokenState.IN_DOUBLE_QUOTE
                        case "\\":
                            # enter backslash state
                            state = TokenState.DEFAULT_BACKSLASH
                        case "~":
                            staging_tokens.extend(home)
                        case _:
                            # append normal characters outside key characters
                            staging_tokens.append(char)

                case TokenState.IN_SINGLE_QUOTE:
                    match char:
                        case "'":
                            # closing the quote, go back to default
                            state = TokenState.DEFAULT
                        case _:
                            # while in quotes append all characters to staging
                            staging_tokens.append(char)

                case TokenState.IN_DOUBLE_QUOTE:
                    match char:
                        case '"':
                            # closing the quote, return to default
                            state = TokenState.DEFAULT
                        case "\\":
                            # enter backslash state
                            state = TokenState.BACKSLASH_IN_DOUBLE_QUOTE
                        case _:
                            # while in quotes append all characters to staging
                            staging_tokens.append(char)

                case TokenState.BACKSLASH_IN_DOUBLE_QUOTE:
                    match char:
                        case '"':
                            # print double quote literal
                            staging_tokens.append(char)
                            # return to double quote state
                            state = TokenState.IN_DOUBLE_QUOTE
                        case "\\":
                            # print backslash literal
                            staging_tokens.append("\\")
                            # return to double quote state
                            state = TokenState.IN_DOUBLE_QUOTE
                        case _:
                            # previous backslash is now treated literally
                            staging_tokens.extend(f"\\{char}")
                            # return to double quote state
                            state = TokenState.IN_DOUBLE_QUOTE

                case TokenState.DEFAULT_BACKSLASH:
                    # ignore all cases, append character to staging
                    staging_tokens.append(char)
                    # return to default state
                    state = TokenState.DEFAULT

                case _:
                    raise ValueError(f"Unknown state {state}")

        # end of line: flush staging tokens
        if staging_tokens:
            final_tokens.append("".join(staging_tokens))

        return final_tokens

    def execute_command(self) -> None:
        builtin = getattr(self.built_ins, self.command, None)
        if callable(builtin):
            builtin(self.args)
            return

        paths = os.environ.get("PATH", "").split(os.pathsep)
        for path in paths:
            file_path = Path(path) / self.command
            if file_path.is_file() and os.access(file_path, os.X_OK):
                subprocess.run([self.command] + self.args)
                return

        print(f"{self.command}: not found")


if __name__ == "__main__":
    shell = Shell()
    while True:
        if not shell.parse(
            line=input("$ "),
        ):
            continue
        shell.execute_command()
