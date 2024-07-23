#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import codecs
import json
import argparse

sys.stdout = codecs.getwriter("utf-8")(sys.stdout.detach())

def read_horusec_json(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
    return data

def clean_text(text):
    """Remoção quebras de linha e caracteres especiais que possam comprometer a tabela."""
    return text.replace('\n', ' ').replace('\r', ' ').replace('|', ' ')

def clean_summary(summary):
    """Remove the initial phrase from the summary."""
    phrase = "(1/1) * Possible vulnerability detected: "
    if summary.startswith(phrase):
        return summary[len(phrase):]
    return summary

def severity_icon(severity):
    """Add severity icon based on severity level."""
    icons = {
        "CRITICAL": "🟣",
        "HIGH": "🔴",
        "MEDIUM": "🟡",
        "LOW": "🟢",
        "INFO": "🔵"
    }
    return icons.get(severity.upper(), "")


def generate_markdown(data, output_path):
    with open(output_path, 'w') as file:
        file.write(f"# Horusec {data.get('version', 'N/A')} - Static Analysis Security Test\n\n")
        # Table of contents
        file.write("- [Horusec - Static Analysis Security Test](#horusec---static-analysis-security-test)\n\n")
        file.write("  - [Scan Info](#scan-info)\n\n")
        file.write("  - [Tabela de Vulnerabilidades](#tabela-de-vulnerabilidades)\n\n")
        file.write("  - [Descrição das Vulnerabilidades](#descrição-das-vulnerabilidades)\n\n")


        file.write("## Scan Info\n\n")
        file.write(f"**Version:** {data.get('version', 'N/A')}\n\n")
        file.write(f"**Status:** {data.get('status', 'N/A')}\n\n")
        file.write(f"**CreatedAt:** {data.get('createdAt', 'N/A')}\n\n")
        file.write(f"**FinishedAt:** {data.get('finishedAt', 'N/A')}\n\n")
        
        file.write("## Tabela de Vulnerabilidades\n\n")
        file.write("| Severity | Rule ID | Sumário | Arquivo:Linha | Ferramenta de Segurança |\n")
        file.write("| --- | --- | --- | --- | --- |\n")
        
        for item in data.get('analysisVulnerabilities', []):
            vulnerability = item.get('vulnerabilities', {})
            severity = vulnerability.get('severity', 'N/A').capitalize()
            icon = severity_icon(severity)
            rule_id = vulnerability.get('rule_id', 'N/A')
            details = vulnerability.get('details', 'N/A')
            summary = clean_text(details.split('\n', 1)[0] if '\n' in details else details)
            if (len(summary) > 254 ):
                summary = f"{clean_summary(summary)[0:249]}..."
            else:
                summary = f"{clean_summary(summary)[0:249]}"
            file_line = f"{vulnerability.get('file', 'N/A')}:{vulnerability.get('line', 'N/A')}"
            security_tool = vulnerability.get('securityTool', 'N/A')
            
            file.write(f"| {icon} {severity} | {rule_id} | {summary} | {file_line} | {security_tool} |\n")
        
        file.write("\n## Descrição das Vulnerabilidades\n\n")
        

        for item in data.get('analysisVulnerabilities', []):
            vulnerability = item.get('vulnerabilities', {})
            severity = vulnerability.get('severity', 'N/A').capitalize()
            icon = severity_icon(severity)
            details = vulnerability.get('details', 'N/A')
            
            # Split details into summary and description
            summary, description = details.split('\n', 1) if '\n' in details else (details, '')
            summary = clean_summary(summary)
            if (len(summary) > 254 ):
                summary_summary = f"{summary[0:100]}..."
            else:
                summary_summary = summary
            
            file_line = f"{vulnerability.get('file', 'N/A')}:{vulnerability.get('line', 'N/A')}"
            code = vulnerability.get('code', 'N/A')
            security_tool = vulnerability.get('securityTool', 'N/A')
            
            file.write(f"### {icon} {summary_summary}\n\n")
            file.write(f"**Severidade:**  {icon} {severity}\n\n")
            file.write(f"**Sumário:** **{clean_text(summary)}**\n\n")
            file.write(f"**Descrição:** {description}\n\n")
            file.write(f"**Arquivo:** {file_line}\n\n")
            file.write(f"**Código:** `{code}`\n\n")
            file.write(f"**Ferramenta de Segurança:** {security_tool}\n\n")
            file.write("\n---\n\n")

def main():
    parser = argparse.ArgumentParser(description="Convert Horusec JSON to Markdown.")
    parser.add_argument("json_path", help="Path to the Horusec JSON file.")
    parser.add_argument("markdown_path", help="Path to save the output Markdown file.")
    args = parser.parse_args()

    horusec_data = read_horusec_json(args.json_path)
    generate_markdown(horusec_data, args.markdown_path)

if __name__ == "__main__":
    main()
