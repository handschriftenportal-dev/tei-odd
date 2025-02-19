#!/usr/bin/env python
from xml.etree import ElementTree as etree


def main():
    document = etree.parse('Gesamt_2021_06_07_obj.xml')
    for data_node in document.findall('Daten'):
        print data_node.find('Zeit').text
        for child_node in data_node:
            if child_node.tag.startswith('Messwert'):
                print ' ->', int(child_node.text)


if __name__ == '__main__':
    main()