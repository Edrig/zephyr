#
# Copyright (c) 2018 Bobby Noelte
#
# SPDX-License-Identifier: Apache-2.0
#

from extract.globals import *
from extract.edts import *

##
# @brief Generate device tree information based on heuristics.
#
# Generates in EDTS:
# - bus/master : device id of bus master for a bus device
# - parent-device : device id of parent device
class DTHeuristics(object):

    def __init__(self):
        pass

    ##
    # @brief Generate device tree information based on heuristics.
    #
    # Device tree properties may have to be deduced by heuristics
    # as the property definitions are not always consistent across
    # different node types.
    #
    # @param node_address Address of node owning the
    #                     compatible definition.
    # @param yaml YAML definition for the owning node.
    #
    def extract(self, node_address, yaml):

        # Check aliases
        if node_address in aliases:
            for i , alias in enumerate(aliases[node_address]):
                edts_insert_device_property(node_address, 'alias/{}'.format(i), alias)

        # Process compatible related work
        try:
            compatible = reduced[node_address]['props']['compatible']
        except KeyError:
            # No compat skip next part
            return

        if not isinstance(compatible, list):
            compatible = [compatible]

        # Check for <device>-device that is connected to a bus
        for compat in compatible:
            if compat not in yaml:
                continue

            if 'parent' not in yaml[compat]:
                continue

            bus_master_device_type = yaml[compat]['parent']['bus']

            # get parent
            parent_node_address = ''
            for comp in node_address.split('/')[1:-1]:
                parent_node_address += '/' + comp

            # get parent yaml
            parent_yaml = yaml[reduced[parent_node_address] \
                                          ['props']['compatible']]

            if bus_master_device_type != parent_yaml['child']['bus']:
                continue

            # generate EDTS
            edts_insert_device_property(node_address, 'bus/master',
                parent_node_address)

        # Check for a parent device this device is subordinated
        edts_insert_device_parent_device_property(node_address)

##
# @brief Management information for heuristics.
heuristics = DTHeuristics()