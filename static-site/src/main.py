import os
import shutil

from markdown2html import markdown_to_html_node


def recursive_file_copy(source, destination):
    if not os.path.exists(destination):
        os.mkdir(destination)

    for item in os.listdir(source):
        new_source = os.path.join(source, item)
        new_destination = os.path.join(destination, item)
        if os.path.isfile(new_source):
            shutil.copy(new_source, destination)
        else:
            recursive_file_copy(new_source, new_destination)


def extract_title(markdown):
    for line in markdown.split("\n"):
        if line.startswith("# "):
            return line.strip("# ")
    raise ValueError("no header in markdown")


def generate_page(from_path, template_path, dest_path):
    print(f"Generating page from {from_path} to {dest_path} using {template_path}")

    with open(from_path, "r") as f:
        markdown = f.read()
    with open(template_path, "r") as f:
        html_template = f.read()

    title = extract_title(markdown)
    html_content = markdown_to_html_node(markdown).to_html()
    html_template = html_template.replace("{{ Title }}", title)
    html_template = html_template.replace("{{ Content }}", html_content)

    dest_dir_path = os.path.dirname(dest_path)
    if dest_dir_path != "":
        os.makedirs(dest_dir_path, exist_ok=True)

    with open(dest_path, "w") as f:
        f.write(html_template)


def generate_page_recursive(dir_path_content, template, dest_dir_path):
    for item in os.listdir(dir_path_content):
        new_source = os.path.join(dir_path_content, item)
        new_destination = os.path.join(dest_dir_path, item)
        if os.path.isfile(new_source):
            generate_page(new_source, template, f"{dest_dir_path}/index.html")
        else:
            generate_page_recursive(new_source, template, new_destination)


def main():
    dest = "./public"
    source = "./static"

    if os.path.exists(dest):
        shutil.rmtree(dest)

    recursive_file_copy(source, dest)

    generate_page_recursive(
        dir_path_content="./content",
        template="template.html",
        dest_dir_path="./public",
    )


if __name__ == "__main__":
    main()
