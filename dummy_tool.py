from typing import Callable
from supercog.engine.tool_factory import ToolFactory, ToolCategory

class DummyTool(ToolFactory):
    def __init__(self):
        super().__init__(
            # Use your company name as a prefix, then any id for the tool
            id = "examplecorp:dummy",
            system_name = "Dummy Tool",
            help = "Example showing how to build new Supercog tools",
            logo_url="https://static.vecteezy.com/system/resources/previews/000/574/204/original/vector-sign-of-download-icon.jpg",
            auth_config = { },
            category=ToolCategory.CATEGORY_SAAS
        )

    def get_tools(self) -> list[Callable]:
        return self.wrap_tool_functions([
            self.calc_fibanocci,
        ])

    def calc_fibanocci(self, n: int) -> list[int]:
        """ Calculates the fibonacci sequence of N.  """
        if n <= 0:
            return []
        elif n == 1:
            return [0]
        elif n == 2:
            return [0, 1]
        
        fib = [0, 1]
        for i in range(2, n):
            fib.append(fib[i-1] + fib[i-2])
        
        return fib
