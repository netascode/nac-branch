# 🌐 templates-internet-policies.nac.yaml File

The **templates-internet-policies.nac.yaml** file in the `data/` folder defines the following template:

- Secure router traffic steering configuration policies - Defined in the **internet_policies** template.

## 📋 internet_policies Configuration Template

The **internet_policies** template provides an example of how to configure SD-WAN policies for Internet traffic (SD-Internet) from the Secure Router. The SD-Internet function is to steer customer traffic to SaaS or public cloud-based applications (outside of any transport tunnel) over the best-performing WAN connection at the time the traffic is forwarded. 

The template defines the following variables:

  - None

The policies within the **internet_policies** template are configured as examples that match the policies within the Unified Branch CVD. Network administrator should configure Internet traffic-steering policies based on the requirements the of their individual organizations.

Note:  It is not recommended to use **wan_traffic_uplink_preferences** within the **app_ts** template  (see the **templates-wan-ts.nac.yaml** file) together with **sdwan_internet_policies** within the **internet_policies** template (see **templates-internet-policies.nac.yaml**).  The latter is a strictly better version of the former, though it requires a license. The two resources share the same set of data in the API, and preferences/policies with e.g. matching source get overridden by the resource created last. Also, deletion of any of the resources deletes the data from the other as well.  

Network as Code Documentation:
https://netascode.cisco.com/docs/data_models/meraki/networks_appliance/sdwan_internet_policies/


