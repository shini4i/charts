#!/usr/bin/env python

import os

import yaml

from prettytable import MARKDOWN
from prettytable import PrettyTable


class Readme:
    def __init__(self):
        self.readme_path = "README.md"
        self.readme_content = self._read_readme()

        self.table_start_marker = "<!-- table_start -->"
        self.table_end_marker = "<!-- table_end -->"

    def _read_readme(self) -> str:
        with open(self.readme_path, "r") as readme_file:
            return readme_file.read()

    @staticmethod
    def _generate_table(charts: list) -> PrettyTable:
        headers = ["Name", "Type", "Description", "Version", "App Version"]
        rows = []

        for chart in charts:
            rows.append(
                [
                    f"[{chart['name']}](https://artifacthub.io/packages/helm/shini4i/{chart['name']})",
                    chart["type"],
                    chart["description"],
                    chart["version"],
                    chart.get("appVersion"),
                ]
            )

        table = PrettyTable(headers)
        table.set_style(MARKDOWN)
        table.add_rows(rows)
        table.sortby = "Name"

        return table

    def _replace_table(self, table: PrettyTable):
        print("Generating new table...")

        table_start = (
                self.readme_content.find(self.table_start_marker)
                + len(self.table_start_marker)
                + 1
        )
        table_end = self.readme_content.find(self.table_end_marker)

        if table_start == len(self.table_start_marker):
            raise IndexError("Table start marker not found")

        self.readme_content = (
            f"{self.readme_content[:table_start]}"
            f"{table.get_string()}\n"
            f"{self.readme_content[table_end:]}"
        )

    def update_readme(self, charts: list):
        table = self._generate_table(charts)

        self._replace_table(table)

        print("Writing new readme...")
        with open(self.readme_path, "w") as readme_file:
            readme_file.write(self.readme_content)


def find_charts():
    charts = []

    for root, dirs, files in os.walk("."):
        if "Chart.yaml" in files and len(root.split("/")) == 3:
            charts.append(os.path.join(root, "Chart.yaml"))

    return charts


def process_helm_chart(chart: str) -> dict:
    with open(chart, "r") as chart_file:
        chart_data = yaml.safe_load(chart_file)

    return {
        "name": chart_data["name"],
        "type": chart_data["type"],
        "description": chart_data["description"],
        "version": chart_data["version"],
        "appVersion": chart_data.get("appVersion"),
    }


def main():
    charts_data = []
    for chart in find_charts():
        print(f"Processing {chart} chart...")
        charts_data.append(process_helm_chart(chart))

    readme = Readme()
    readme.update_readme(charts_data)


if __name__ == "__main__":
    main()
