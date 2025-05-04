import re
from enum import Enum


class BlockType(Enum):
    PARAGRAPH = "paragraph"
    HEADING = "heading"
    CODE = "code"
    QUOTE = "quote"
    UNORDERED_LIST = "unordered_list"
    ORDERED_LIST = "ordered_list"


class TextType(Enum):
    TEXT = "text"
    BOLD = "bold"
    ITALIC = "italic"
    CODE = "code"
    LINK = "link"
    IMAGE = "image"


class HTMLNode:
    def __init__(self, tag=None, value=None, children=None, props=None):
        self.tag = tag
        self.value = value
        self.children = children
        self.props = props

    def to_html(self):
        raise NotImplementedError("to_html method not implemented")

    def props_to_html(self):
        if self.props is None:
            return ""
        return "".join(f' {key}="{value}"' for key, value in self.props.items())

    def __repr__(self):
        return f"HTMLNode({self.tag}, {self.value}, children: {self.children}, {self.props})"


class ParentNode(HTMLNode):
    def __init__(self, tag, children, props=None):
        super().__init__(tag=tag, children=children, props=props)

    def to_html(self):
        if self.tag is None:
            raise ValueError("invalid HTMLNode: no tag")
        if self.children is None:
            raise ValueError("invalid HTMLNode: no children")
        children_html = "".join(child.to_html() for child in self.children)
        return f"<{self.tag}{self.props_to_html()}>{children_html}</{self.tag}>"

    def __repr__(self):
        return f"ParentNode({self.tag}, children: {self.children}, {self.props})"


class LeafNode(HTMLNode):
    def __init__(self, tag=None, value="", props=None):
        super().__init__(tag=tag, value=value, props=props)

    def to_html(self):
        if self.value is None:
            raise ValueError("invalid HTMLNode: no value")
        if self.tag is None:
            return self.value
        return f"<{self.tag}{self.props_to_html()}>{self.value}</{self.tag}>"

    def __repr__(self):
        return f"LeafNode({self.tag}, {self.value}, {self.props})"


class TextNode:
    def __init__(self, text, text_type, url=None):
        self.text = text
        self.text_type = text_type
        self.url = url

    def __eq__(self, other):
        return (
            self.text == other.text
            and self.text_type == other.text_type
            and self.url == other.url
        )

    def __repr__(self):
        return f"TextNode({self.text}, {self.text_type.value}, {self.url})"


def text_node_to_html_node(text_node):
    match text_node.text_type:
        case TextType.TEXT:
            return LeafNode(
                value=text_node.text,
            )
        case TextType.BOLD:
            return LeafNode(
                tag="b",
                value=text_node.text,
            )
        case TextType.ITALIC:
            return LeafNode(
                tag="i",
                value=text_node.text,
            )
        case TextType.CODE:
            return LeafNode(
                tag="code",
                value=text_node.text,
            )
        case TextType.LINK:
            return LeafNode(
                tag="a", value=text_node.text, props={"href": text_node.url}
            )
        case TextType.IMAGE:
            return LeafNode(
                tag="img",
                props={
                    "src": text_node.url,
                    "alt": text_node.text,
                },
            )
        case _:
            raise Exception(f"invalid text type: {text_node.text_type}")


def split_nodes_delimiter(old_nodes, delimiter, text_type):
    new_nodes = []

    for node in old_nodes:
        if node.text_type != TextType.TEXT:
            new_nodes.append(node)
            continue

        split_text = node.text.split(delimiter)

        for index, text in enumerate(split_text):

            if not text.strip():
                continue

            if index % 2 == 0:
                node_type = TextType.TEXT
            else:
                node_type = text_type

            text_node = TextNode(
                text=text,
                text_type=node_type,
            )
            new_nodes.append(text_node)

    return new_nodes


def extract_markdown_images(text):
    pattern = r"!\[([^]]*)\]\(([^)]+)\)"
    # simple_wrong_pattern = r"!\[(.*?)\]\((.*?)\)"
    matches = re.findall(pattern, text)
    return matches


def extract_markdown_links(text):
    pattern = r"(?<!\!)\[([^]]+)\]\(([^)]+)\)"
    # simple_wrong_pattern = r"\[(.*?)\]\((.*?)\)"
    matches = re.findall(pattern, text)
    return matches


def split_nodes_image(old_nodes):
    new_nodes = []

    for node in old_nodes:
        if node.text_type != TextType.TEXT:
            new_nodes.append(node)
            continue

        original_text = node.text
        images = extract_markdown_images(original_text)

        for text, url in images:
            image = f"![{text}]({url})"
            split_text = original_text.split(image, 1)

            if len(split_text) != 2:
                raise ValueError("invalid markdown, image section not closed")

            if split_text[0] != "":
                new_nodes.append(
                    TextNode(
                        text=split_text[0],
                        text_type=TextType.TEXT,
                    )
                )
            new_nodes.append(
                TextNode(
                    text=text,
                    text_type=TextType.IMAGE,
                    url=url,
                )
            )
            original_text = split_text[1]

        if original_text != "":
            new_nodes.append(
                TextNode(
                    text=original_text,
                    text_type=TextType.TEXT,
                )
            )
    return new_nodes


def split_nodes_link(old_nodes):
    new_nodes = []

    for node in old_nodes:
        if node.text_type != TextType.TEXT:
            new_nodes.append(node)
            continue

        original_text = node.text
        links = extract_markdown_links(original_text)

        for text, url in links:
            link = f"[{text}]({url})"
            split_text = original_text.split(link, 1)
            if len(split_text) != 2:
                raise ValueError("invalid markdown, link section not closed")

            if split_text[0] != "":
                new_nodes.append(
                    TextNode(
                        text=split_text[0],
                        text_type=TextType.TEXT,
                    )
                )
            new_nodes.append(
                TextNode(
                    text=text,
                    text_type=TextType.LINK,
                    url=url,
                )
            )
            original_text = split_text[1]
        if original_text != "":
            new_nodes.append(
                TextNode(
                    text=original_text,
                    text_type=TextType.TEXT,
                )
            )
    return new_nodes


def text_to_textnodes(text):
    node = [
        TextNode(
            text=text,
            text_type=TextType.TEXT,
        )
    ]
    new_nodes = split_nodes_delimiter(node, "**", TextType.BOLD)
    new_nodes = split_nodes_delimiter(new_nodes, "_", TextType.ITALIC)
    new_nodes = split_nodes_delimiter(new_nodes, "`", TextType.CODE)
    new_nodes = split_nodes_image(new_nodes)
    new_nodes = split_nodes_link(new_nodes)
    return new_nodes


def markdown_to_blocks(markdown):
    lines = []
    for line in markdown.split("\n\n"):
        if line == "":
            continue
        lines.append(line.strip())
    return lines


def block_to_block_type(md_block):
    lines = md_block.split("\n")
    if md_block.startswith(("#", "##", "###", "####", "#####", "######")):
        return BlockType.HEADING
    if len(lines) > 1 and lines[0].startswith("```") and lines[-1].startswith("```"):
        return BlockType.CODE
    if md_block.startswith(">"):
        for line in lines:
            if not line.startswith(">"):
                return BlockType.PARAGRAPH
        return BlockType.QUOTE
    if md_block.startswith("* ") or md_block.startswith("- "):
        for line in lines:
            if not (line.startswith("* ") or line.startswith("- ")):
                return BlockType.PARAGRAPH
        return BlockType.UNORDERED_LIST
    if md_block.startswith("1."):
        i = 1
        for line in lines:
            if not line.startswith(f"{i}. "):
                return BlockType.PARAGRAPH
            i += 1
        return BlockType.ORDERED_LIST
    return BlockType.PARAGRAPH


def markdown_to_html_node(markdown):
    blocks = markdown_to_blocks(markdown)
    children = []
    for block in blocks:
        html_node = block_to_html_node(block)
        children.append(html_node)
    return ParentNode(
        tag="div",
        children=children,
    )


def block_to_html_node(block):
    block_type = block_to_block_type(block)
    if block_type == BlockType.PARAGRAPH:
        return paragraph_to_html_node(block)
    if block_type == BlockType.HEADING:
        return heading_to_html_node(block)
    if block_type == BlockType.CODE:
        return code_to_html_node(block)
    if block_type == BlockType.QUOTE:
        return quote_to_html_node(block)
    if block_type == BlockType.UNORDERED_LIST:
        return unorderedlist_to_html_node(block)
    if block_type == BlockType.ORDERED_LIST:
        return orderedlist_to_html_node(block)
    raise Exception("Invalid block type")


def text_to_children(text):
    text_nodes = text_to_textnodes(text=text)
    children = []
    for text_node in text_nodes:
        html_node = text_node_to_html_node(text_node)
        children.append(html_node)
    return children


def paragraph_to_html_node(block):
    lines = block.split("\n")
    paragraph = " ".join(lines)
    children = text_to_children(paragraph)
    return ParentNode("p", children)


def heading_to_html_node(block):
    if block.startswith("# "):
        text = block.replace("# ", "")
        children = text_to_children(text)
        return ParentNode("h1", children)
    if block.startswith("## "):
        text = block.replace("## ", "")
        children = text_to_children(text)
        return ParentNode("h2", children)
    if block.startswith("### "):
        text = block.replace("### ", "")
        children = text_to_children(text)
        return ParentNode("h3", children)
    if block.startswith("#### "):
        text = block.replace("#### ", "")
        children = text_to_children(text)
        return ParentNode("h4", children)
    if block.startswith("##### "):
        text = block.replace("##### ", "")
        children = text_to_children(text)
        return ParentNode("h5", children)
    raise ValueError("Invalid heading level")


def code_to_html_node(block):
    if not block.startswith("```") or not block.endswith("```"):
        raise ValueError("invalid code block")
    text = block.replace("```", "")
    text_node = TextNode(text, TextType.TEXT)
    child = text_node_to_html_node(text_node)
    code = ParentNode(tag="code", children=[child])
    return ParentNode(tag="pre", children=[code])


def quote_to_html_node(block):
    lines = block.split("\n")
    new_lines = []
    for line in lines:
        if not line.startswith(">"):
            raise ValueError("invalid quote block")
        new_lines.append(line.lstrip(">").strip())
    content = " ".join(new_lines)
    children = text_to_children(content)
    return ParentNode("blockquote", children)


def unorderedlist_to_html_node(block):
    lines = block.split("\n")
    new_lines = []
    for line in lines:
        children = text_to_children(line[2:])
        new_lines.append(ParentNode("li", children))
    return ParentNode("ul", new_lines)


def orderedlist_to_html_node(block):
    lines = block.split("\n")
    new_lines = []
    for line in lines:
        children = text_to_children(line[3:])
        new_lines.append(ParentNode("li", children))
    return ParentNode("ol", new_lines)
