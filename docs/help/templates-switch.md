# 🌐 templates-switch.nac.yaml File

The **templates-switch.nac.yaml** file in the `data/` folder defines the following templates which provide the following set of Unified Branch services applicable to the switch platforms within branches:

- Switch Radius access policy - defined in the **switch_access_policy** template
- Switch stack configuration - defined in the **switch_stack** tamplate
- Spanning-tree protocol (STP) configuration - defined in the **switch_stp** template
- Link aggregation group (LAG) configuration - defined in the **switch_link_aggregations** template
- Switch configurations for the small, medium, and large branches - defined in the **switch** template

Note that these templates are not related to templates configured within the Cisco (formerly Meraki) dashboard.

## 📋 switch_access_policy Configuration Template

The **switch_access_policy** template references the **switch_access_policy.yaml.tftpl** file which holds the actual configuration for the switch Radius access policy, and allows for the support of a variable number of Radius and Radius accounting servers to be defined.  

The **switch_access_policy** template configures a wired radius policy for authentication of endpoints to the switch / switch stack, including the following: 

- 802.1x hybrid authentication with RADIUS for wired network access control
- RADIUS accounting for audit trails and session tracking
- Change of Authorization (CoA) support for dynamic policy updates
- Multi-Auth mode allowing multiple devices per port
- Voice VLAN domain support for IP phones

The template defines the following variables:

Under **radius_servers**:
- **host**: String - Radius Server IP address
- **port**: Integer - Radius Server port
- **secret**: String - Radius Server secret

Under **radius_accounting_servers**:
- **host**: String  - Radius Server IP address
- **port**: String  - Radius Server port
- **secret**: String  - Radius Server secret

Note, some customers prefer Multi-Domain over Multi-Auth mode, but only if they can guarantee a rigid and predictable environment.  For instance, a single PC connected and single phone per port.  However, this may not work well in many real-world deployments involving devices which have hub-like behaviors, devices with docking stations, thin clients, virtual devices, etc.; which could have multiple mac addresses of credential requirements. Hence, a more conservative approach would be to start with Multi-Auth.  Once the implementation has stabilized and there is a clear understanding of assets and the credential requirements, the customer can optionally move to Multi-Domain as it is marginally more secure.  Hence, for Unified Branch Phase 2, Multi-Auth configuration for access switch ports has been selected.  For those customers who are able to implement tighter security environments where they can guarantee one phone and one device / mac address, then they can choose to modify the YAML to use Multi-Domain if needed.


## 📋 switch_stack Configuration Template

The **switch_stack** template references the **switch_stacks.yaml.tftpl** file which holds the configuration for switch stacks implemented within the branches, and allows for the support of a variable number of switch stacks, with a variable numer of switches to be defined.  

The template defines the following variables:

Under **stacks**:
- **name**: String - Name of the switch stack
- **devices**: List of Strings - List of the serial numbers of the switches which are are part of the stack.

Note that if the deployment does not contain switch stacks or the deployment implements some individual access switches instead of switch stacks in a large branch design, the customer / partner will need to manually modify the YAML to accomodate the configuration.

## 📋 switch_stp Configuration Template

The **switch_stp** template references the **switch_stp.yaml.tftpl** file which holds the configuration for rapid spanning-tree protocol implemented within the branches.  It allows for multiple spanning-tree bridge priority settings, each with the support of a variable number of switch stacks with that priority.  

The template defines the following variables:

Under **stp_bridge_priority**:
- **stp_priority**: Number - STP priority (lower number is a higher priority)
- **stacks**: List of Strings - List of the names of the switch stacks which have this STP priority.

The intention of the **switch_stp** template is to configure a distribution switch stack within the large branch with a lower bridge priority (4096) over one or more access switch stacks with a higher bridge priority (8096).  This ensures the distribution switch stack is the root bridge for the large branch design.  For small and medium branch designs, simply set the single switch stack within the branch with a bridge priority of 4096.

Note that if the deployment does not contain switch stacks or the deployment implements some individual access switches instead of switch stacks in a large branch design, the customer / partner will need to manually modify the YAML to accomodate the configuration.

Rapid spanning-tree protocol (RTSP) is enabled within the template. 


## 📋 switch_link_aggregations Configuration Template

The **switch_link_aggregations** template references the **switch_link_aggregations.yaml.tftpl** file which holds the configuration for switch link aggregation (LAG) groups implemented within the branches.  It allows for multiple LAG groups, each with the support of a variable number of switch ports within the group.  

The template defines the following variables:

Under **link_aggregations**:
  - **link_aggregation_name**: String - Name of the link aggregation group.
  -Under **switch_ports**: 
     - **device**: String - Serial number of the switch
     - **port_id**: Number - Switch port ID

The intention of the **link_aggregations** template is to configure a multi-chassis link aggregation group for redundancy between each access switch stack and the distribution switch stack in a large branch deployment.  Port IDs are based on the configuration of the switch ports within the **large_branch_inventory** template within the **data/templates-inventory.nac.yaml** file.  The Unified Branch CVD discusses the link aggregation design. 

Note that the link aggregation configuration only applies to the large branch design, since the small and medium branch designs have only a single switch or switch stack. 


## 📋 switch Configuration Template

The **switch** configuration template includes switch heirachy and setup, QoS, and network policies for the small, medium, and large branch designs including the following:

Switch Settings:
- Management VLAN 999 for out-of-band management (migrates from VLAN 1 after onboarding)
- Uplink client sampling for traffic analytics
- Jumbo frame support with MTU configuration configured as a variable
- IGMP snooping for multicast optimization

Quality of Service:
- Default switch DSCP to CoS (queue) mappings (explicitly configured)
- Per-VLAN QoS rules for traffic classification and marking
   - Guest traffic re-marked to default (DSCP 0)
   - Data, Voice, IoT, and PCI traffic trusted 

Network Protection:
- Storm control limiting broadcast/multicast/unknown unicast traffic.

The template defines the following variables:

- **switch_mtu_size**: Integer (min=1, max=9578) - MTU size of the switch