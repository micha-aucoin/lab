class Graph:
    def __init__(self):
        self.graph = {}

    def __repr__(self):
        result = ""
        for key in self.graph.keys():
            result += f"Vertex: '{key}'\n"
            for v in sorted(self.graph[key]):
                result += f"has an edge leading to --> {v} \n"
        return result

    def add_edge(self, u, v):
        if u in self.graph.keys():
            self.graph[u].add(v)
        else:
            self.graph[u] = set([v])
        if v in self.graph.keys():
            self.graph[v].add(u)
        else:
            self.graph[v] = set([u])

    def breadth_first_search(self, v):
        visted = []
        queue = []
        queue.append(v)
        while queue:
            visted.append(queue.pop(0))
            neighbors = sorted(self.graph[v])
            for neighbor in neighbors:
                if neighbor not in visted and neighbor not in queue:
                    queue.append(neighbor)
        return visted

    def depth_first_search(self, start_vertex):
        visted = []
        self.depth_first_search_r(visted, start_vertex)
        return visted

    def depth_first_search_r(self, visited, current_vertex):
        visited.append(current_vertex)
        neighbors = sorted(self.graph[current_vertex])
        print(neighbors)
        for neighbor in neighbors:
            if neighbor not in visited:
                self.depth_first_search_r(visited, neighbor)
