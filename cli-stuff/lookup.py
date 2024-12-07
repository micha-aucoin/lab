import argparse
import re
import sys
import textwrap


def filter_doc(document_path, regex):
    with open(document_path, "r") as file:
        content = file.read()

    return "\n".join(
        filter(
            lambda x: not re.match(regex, x),
            content.splitlines(),
        ),
    )


# Example usage
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="lookup",
        formatter_class=argparse.RawTextHelpFormatter,
        description="Filter document lines.",
        epilog=textwrap.dedent(
            """\
        Example usage:
        --------------
        cat text.txt; \\
        echo '-----------------------'; \\
        echo '^^^^^^_old_|_new_vvvvvv'; \\
        echo '-----------------------'; \\
        python lookup.py '^-' text.txt
            """
        ),
    )
    parser.add_argument("regex", help="Regex pattern to match lines to be removed")
    parser.add_argument("document", help="Path to the document file")
    args = parser.parse_args()

    filtered_doc = filter_doc(args.document, args.regex)
    print(filtered_doc)
