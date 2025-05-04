import unittest

from markdown2html import (
    TextNode,
    TextType,
    extract_markdown_images,
    extract_markdown_links,
    split_nodes_delimiter,
    split_nodes_image,
    split_nodes_link,
    text_node_to_html_node,
    text_to_textnodes,
)


class TestTextNode(unittest.TestCase):
    def test_eq(self):
        kwargs = {
            "text": "this is a text node",
            "text_type": TextType.BOLD,
        }
        node = TextNode(**kwargs)
        node2 = TextNode(**kwargs)
        self.assertEqual(node, node2)

    def test_not_eq1(self):
        node = TextNode(text="this is a text node", text_type=TextType.TEXT)
        node2 = TextNode(text="this is a text node2", text_type=TextType.TEXT)
        self.assertNotEqual(node, node2)

    def test_not_eq2(self):
        node = TextNode(text="this is a text node", text_type=TextType.BOLD)
        node2 = TextNode(text="this is a text node", text_type=TextType.TEXT)
        self.assertNotEqual(node, node2)

    def test_url_eq(self):
        kwargs = {
            "text": "this is a text node",
            "text_type": TextType.BOLD,
            "url": "https://www.com",
        }
        node = TextNode(**kwargs)
        node2 = TextNode(**kwargs)
        self.assertEqual(node, node2)

    def test_print(self):
        node = TextNode(
            text="this is a text node", text_type=TextType.BOLD, url="https://www.com"
        )
        result = "TextNode(this is a text node, bold, https://www.com)"
        self.assertEqual(node.__repr__(), result)


class TestTextNodeToHTMLNode(unittest.TestCase):
    def test_text(self):
        node = TextNode(
            text="This is a text node",
            text_type=TextType.TEXT,
        )
        html_node = text_node_to_html_node(node)
        self.assertEqual(html_node.tag, None)
        self.assertEqual(html_node.value, "This is a text node")

    def test_image(self):
        node = TextNode(
            text="This is an image",
            text_type=TextType.IMAGE,
            url="https://www.com",
        )
        html_node = text_node_to_html_node(node)
        html = '<img src="https://www.com" alt="This is an image"></img>'
        props = {"src": "https://www.com", "alt": "This is an image"}
        self.assertEqual(html_node.tag, "img")
        self.assertEqual(html_node.value, "")
        self.assertEqual(html_node.to_html(), html)
        self.assertEqual(html_node.props, props)

    def test_bold(self):
        node = TextNode("This is bold", TextType.BOLD)
        html_node = text_node_to_html_node(node)
        self.assertEqual(html_node.tag, "b")
        self.assertEqual(html_node.value, "This is bold")


class TestSplitNodes(unittest.TestCase):
    def test_split_code_nodes(self):
        node = TextNode(
            text="This is text with a `code block` word and another `code block`",
            text_type=TextType.TEXT,
        )
        new_nodes = split_nodes_delimiter([node], "`", TextType.CODE)
        result = [
            TextNode("This is text with a ", TextType.TEXT),
            TextNode("code block", TextType.CODE),
            TextNode(" word and another ", TextType.TEXT),
            TextNode("code block", TextType.CODE),
        ]
        self.assertEqual(new_nodes, result)

    def test_split_bold_nodes(self):
        node = TextNode(
            text="This is text with a **bold** word",
            text_type=TextType.TEXT,
        )
        new_nodes = split_nodes_delimiter([node], "**", TextType.BOLD)
        result = [
            TextNode("This is text with a ", TextType.TEXT),
            TextNode("bold", TextType.BOLD),
            TextNode(" word", TextType.TEXT),
        ]
        self.assertEqual(new_nodes, result)

    def test_split_italic_nodes(self):
        node = TextNode(
            text="This is text with a *italic* word",
            text_type=TextType.TEXT,
        )
        new_nodes = split_nodes_delimiter([node], "*", TextType.ITALIC)
        result = [
            TextNode("This is text with a ", TextType.TEXT),
            TextNode("italic", TextType.ITALIC),
            TextNode(" word", TextType.TEXT),
        ]
        self.assertEqual(new_nodes, result)

    def test_delim_bold_and_italic(self):
        node = TextNode("**bold** and *italic*", TextType.TEXT)
        new_nodes = split_nodes_delimiter([node], "**", TextType.BOLD)
        new_nodes = split_nodes_delimiter(new_nodes, "*", TextType.ITALIC)
        result = [
            TextNode("bold", TextType.BOLD),
            TextNode(" and ", TextType.TEXT),
            TextNode("italic", TextType.ITALIC),
        ]
        self.assertListEqual(new_nodes, result)


class TestExtractMarkdown(unittest.TestCase):
    def test_extract_markdown_images(self):
        text = "This is text with a ![rick roll](https://i.imgur.com/aKaOqIh.gif) and ![obi wan](https://i.imgur.com/fJRm4Vk.jpeg)"
        markdown_imgs = extract_markdown_images(text)
        result = [
            ("rick roll", "https://i.imgur.com/aKaOqIh.gif"),
            ("obi wan", "https://i.imgur.com/fJRm4Vk.jpeg"),
        ]
        self.assertEqual(markdown_imgs, result)

    def test_extract_markdown_links(self):
        text = "This is text with a [link](https://www.com) and [another link](https://www.com)"
        markdown_imgs = extract_markdown_links(text)
        result = [("link", "https://www.com"), ("another link", "https://www.com")]
        self.assertEqual(markdown_imgs, result)

    def test_split_link_nodes(self):
        node = TextNode(
            text="This is text with a link [to web](https://www.com) and [to youtube](https://www.youtube.com)",
            text_type=TextType.TEXT,
        )
        new_nodes = split_nodes_link([node])
        result = [
            TextNode("This is text with a link ", TextType.TEXT),
            TextNode("to web", TextType.LINK, "https://www.com"),
            TextNode(" and ", TextType.TEXT),
            TextNode("to youtube", TextType.LINK, "https://www.youtube.com"),
        ]
        self.assertEqual(new_nodes, result)

    def test_split_image_nodes(self):
        node = TextNode(
            text="This is text with a ![rick roll](https://i.imgur.com/aKaOqIh.gif) and ![obi wan](https://i.imgur.com/fJRm4Vk.jpeg) and something else",
            text_type=TextType.TEXT,
        )
        new_nodes = split_nodes_image([node])
        result = [
            TextNode("This is text with a ", TextType.TEXT),
            TextNode("rick roll", TextType.IMAGE, "https://i.imgur.com/aKaOqIh.gif"),
            TextNode(" and ", TextType.TEXT),
            TextNode("obi wan", TextType.IMAGE, "https://i.imgur.com/fJRm4Vk.jpeg"),
            TextNode(" and something else", TextType.TEXT),
        ]
        self.assertEqual(new_nodes, result)

    def test_text_to_textnodes(self):
        text = "This is **text** with an _italic_ word and a `code block` and an ![obi wan image](https://i.imgur.com/fJRm4Vk.jpeg) and a [link](https://boot.dev)"
        new_nodes = text_to_textnodes(text)
        result = [
            TextNode("This is ", TextType.TEXT),
            TextNode("text", TextType.BOLD),
            TextNode(" with an ", TextType.TEXT),
            TextNode("italic", TextType.ITALIC),
            TextNode(" word and a ", TextType.TEXT),
            TextNode("code block", TextType.CODE),
            TextNode(" and an ", TextType.TEXT),
            TextNode(
                "obi wan image", TextType.IMAGE, "https://i.imgur.com/fJRm4Vk.jpeg"
            ),
            TextNode(" and a ", TextType.TEXT),
            TextNode("link", TextType.LINK, "https://boot.dev"),
        ]
        self.assertEqual(new_nodes, result)


if __name__ == "__main__":
    unittest.main()
