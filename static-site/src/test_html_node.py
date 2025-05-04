import unittest

from markdown2html import HTMLNode, LeafNode, ParentNode


class TestHTMLNode(unittest.TestCase):
    def test_props_to_html(self):
        node = HTMLNode(
            tag="a", value="this is the value", props={"key": "value", "key2": "value2"}
        )
        result = ' key="value" key2="value2"'
        self.assertEqual(node.props_to_html(), result)

    def test_values(self):
        node = HTMLNode(tag="div", value="I wish I could read")
        self.assertEqual(node.tag, "div")
        self.assertEqual(node.value, "I wish I could read")
        self.assertEqual(node.children, None)
        self.assertEqual(node.props, None)

    def test_repr(self):
        node = HTMLNode(
            tag="p",
            value="What a strange world",
            children=None,
            props={"class": "primary"},
        )
        result = (
            "HTMLNode(p, What a strange world, children: None, {'class': 'primary'})"
        )
        self.assertEqual(node.__repr__(), result)

    def test_leaf_to_htlp(self):
        node = LeafNode(
            tag="p", value="What a strange world", props={"class": "primary"}
        )
        result = '<p class="primary">What a strange world</p>'
        self.assertEqual(node.to_html(), result)

    def test_leaf_to_html_no_tag(self):
        node = LeafNode(value="What a strange world")
        result = "What a strange world"
        self.assertEqual(node.to_html(), result)

    def test_leaf_values(self):
        node = LeafNode(tag="div", value="I wish I could read")
        self.assertEqual(node.tag, "div")
        self.assertEqual(node.value, "I wish I could read")
        self.assertEqual(node.children, None)
        self.assertEqual(node.props, None)

    def test_leaf_repr(self):
        node = LeafNode(
            tag="p", value="What a strange world", props={"class": "primary"}
        )
        result = "LeafNode(p, What a strange world, {'class': 'primary'})"
        self.assertEqual(node.__repr__(), result)

    def test_parent_values(self):
        node = ParentNode(
            "p",
            [
                LeafNode("b", "Bold text"),
                LeafNode(None, "Normal text"),
                LeafNode("i", "italic text"),
                LeafNode(None, "Normal text"),
            ],
        )
        result = "<p><b>Bold text</b>Normal text<i>italic text</i>Normal text</p>"
        self.assertEqual(node.to_html(), result)

    def test_parent_nesting(self):
        node = ParentNode(
            "p",
            [
                ParentNode(
                    "p", [LeafNode("b", "Bold text")], props={"class": "primary"}
                ),
                LeafNode(None, "Normal text"),
                LeafNode("i", "italic text"),
                LeafNode(None, "Normal text"),
            ],
        )
        result = '<p><p class="primary"><b>Bold text</b></p>Normal text<i>italic text</i>Normal text</p>'
        self.assertEqual(node.to_html(), result)

    def test_parent_with_grandchildren(self):
        grandchild_node = LeafNode("b", "grandchild")
        child_node = ParentNode("span", [grandchild_node])
        parent_node = ParentNode("div", [child_node])
        result = "<div><span><b>grandchild</b></span></div>"
        self.assertEqual(parent_node.to_html(), result)


if __name__ == "__main__":
    unittest.main()
