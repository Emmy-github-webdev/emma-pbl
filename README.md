# emma-pbl

_install graphviz_

```
sudo apt install graphviz

```

_use the command below to generate dependency graph_

```
terraform graph -type=plan | dot -Tpng > graph.png
terraform graph | dot -Tpng > graph.png
```

[For more information](https://www.terraform.io/cli/commands/graph)