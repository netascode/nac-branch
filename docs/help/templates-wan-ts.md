# 🌐 templates-wan-ts.nac.yaml File

WAN services for the small branch consist of the following:

- WAN Connectivity
- WAN Traffic Shaping & Traffic Steering

WAN traffic shaping & traffic steering services are implemented by the MX secure router.  The **templates-wan-ts.nac.yaml** file in the `data/` folder defines the following template, which implements traffic shaping and traffic steering configurations for the branch.

- Secure router traffic shaping - defined in the **app_ts** configuration template.

Note that WAN VPN exclusions have been moved to the **templates-wan-vpn-exclusions.nac.yaml** file in the `data/` folder for Unified Branch Phase 2.

WAN connectivity services are defined in the various templates within the **templates-wan-uplinks.nac.yaml** file. 


## 📋 app_ts Configuration Template

The **app_ts** template applies to VPN (AutoVPN tunneled) traffic across the WAN interfaces of the security appliance.

The template defines the following variables:

- **wan_limit_up**: Integer (min=0, max=1000000) -  upstream per-client rate-limit (0 = unlimited)
- **wan_limit_down**: Integer (min=0, max=1000000) - Secure router downstream per-client rate-limit (0 = unlimited)
- **wan1_limit_up**: Integer (min=0, max=1000000) - Secure router WAN1 interface upstream rate-limit (0 = unlimited)
- **wan1_limit_down**: Integer (min=0, max=1000000) - Secure router WAN1 interface downstream rate-limit (0 = unlimited)
- **wan2_limit_up**: Integer (min=0, max=1000000) - Secure router WAN2 interface upstream rate-limit (0 = unlimited)
- **wan2_limit_down**: Integer (min=0, max=1000000) - Secure router WAN2 interface downstream rate-limit (0 = unlimited)

The **app_ts** template consists of the following sections:

- vpn_exclusions
- global_bandwidth_limits
- custom_performance_classes
- rules
- uplink_bandwidth_limits
- uplink_selection
  - vpn_traffic_uplink_preferences sub-section
  - wan_traffic_uplink_preferences sub-section

### 🔍 global_bandwidth_limits Section

The global_bandwidth_limits section configures per-client rate-limiting both upstream and downstream.  For the Unified Branch CVD, these are set to unlimited. This can be accomplished by setting **wan_limit_up** and **wan_limit_down** to 0.

### 🔍 custom_performance_classes Section

The custom_performance_classes section defines two example custom (non-builtin) performance classes, also discussed within the Unified Branch CVD.

- The first performance class, **SaaS_Traffic**, sets the max latency at 150 ms, the max jitter tolerance at 50 milliseconds, and the max loss percentage at 5% in order for traffic to be within the SLA of the performance class.  

- The second performance class, **Critical_Apps**, sets the max latency at 150 ms, the max jitter tolerance at 20 milliseconds, and the max loss percentage at 2% in order for traffic to be within the SLA of the performance class.  

- A third performance class, **Default_SLA**, is automatically created by the Meraki dashboard, and does not appear within the YAML configuration below. It sets no maximum latency, a max jitter tolerance of 100 milliseconds, and a max loss percentage of 5% in order for traffic to be within the SLA of the performance class.

Note that performance classes can apply to either VPN or non-VPN (Internet) traffic across WAN uplinks.

### 🔍 Traffic Shaping rules Section

Traffic shaping **rules** can be applied per client and per application to optimize network performance and ensure critical applications receive the necessary bandwidth.

Rule actions include setting bandwidth limits (upload/download), prioritizing traffic (High, Normal, Low), and applying DSCP tagging for QoS prioritization.

The examples shown within the **app_ts** template are based on the Unified Branch CVD, which do the following:

 - Set Guest traffic (172.16.99.0/14) to DSCP value of default (0) and priority to low.

 - Set traffic to the Critical Apps server (10.102.1.161/32, port 443) to DSCP value of AF21 (18) and priority of high.

Update the rules as needed to fit your requirements.

### 🔍 uplink_bandwidth_limits Section

The **uplink_bandwidth_limits** section sets the uplink and downlink bandwidth limits for all traffic from all clients on each WAN uplink. This is essentially equivalent to sub-line rate limiting to the speed of carrier, even though the physical connection may be 1 Gbps Ethernet.

The Unified Branch CVD configuration sets the rate-limit to 400,000 Kbps(400 Mbps) upstream and downstream for WAN 1 uplinks and 500 Mbps for WAN 2. The limits within the YAML below are configured as variables so that they can be easily adjusted to your deployment.

### 🔍 uplink_selection Section

The **uplink_selection** section is configured to match the Unified Branch CVD. AutoVPN tunnels are set to be created over both uplinks. Fallback is set to graceful, which allows active sessions continue on the old link until they expire, instead of forcing the traffic to move immediately to the new path. Load-balancing of Internet traffic is disabled, with WAN1 configured as the primary uplink.

#### 🔍 wan_traffic_uplink_preferences Sub-Section

The **wan_traffic_uplink_preferences** section is not used for the Unified Branch CVD, and is therefore not used within the **app_ts** template. See the configuration within the **internet_policies** template in the **templates_internet_policies.nac.yaml** file for non-VPN (Internet) traffic uplink preferences

The **wan_traffic_uplink_preferences** sub-section of the **app_ts**  template applies to non-AutoVPN (Internet-bound) traffic only.  You should use either the **wan_traffic_uplink_preferences** sub-section within the **app_ts** template, or use the **sdwan_internet_policies** in the **internet_policies** template within the **templates-internet-policies.nac.yaml** file, but not both.

#### 🔍 vpn_traffic_uplink_preferences Sub-Section

The **vpn_traffic_uplink_preferences** sub-section is for VPN traffic uplink preferences on secure routers (appliances).  The following three rules are configured in the Unified Branch CVD:

- VoIP & videoconferencing traffic uses WAN2 unless outside the SLA of the builtin **VoIP** performance class.

- Traffic to corporate server 10.102.1.161 uses WAN2 unless outside the SLA of the custom **Critical_Apps** performance class. Note, this example uses an IP address within the hub network, specific to the Unified Branch CVD. Customize as needed for your deployment.

- All other traffic across the AutoVPN tunnels uses WAN1 unless outside the SLA of the automatically created **Default_SLA** performance class.