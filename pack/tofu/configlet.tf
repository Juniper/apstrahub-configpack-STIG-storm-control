#  Copyright (c) Juniper Networks, Inc., 2025-2025.
#  All rights reserved.
#  SPDX-License-Identifier: MIT

resource "apstra_datacenter_configlet" "example" {
  blueprint_id = var.blueprint_id
  condition    = "role in [\"leaf\", \"access\"]"
  name = var.name
  generators = [
    {
      config_style  = "junos"
      section       = "top_level_hierarchical"
      template_text = <<-EOT
        forwarding-options {
            storm-control-profiles default {
                all;
            }
          }
        {% for int, int_info in interface.items() %}
        {% if ((int_info.role == "l2edge") and (int_info.lag_mode is none )) %}
        interfaces {
          {{ int_info.intfName }} {
            unit 0 {
              family ethernet-switching {
                storm-control default;
              }
            }
          }
        }
        {% endif %}
        {% if ((int_info.role == "l2edge") and ('ae' in int_info.intfName) ) %}
        interfaces {
          {{ int_info.intfName }} {
            unit 0 {
              family ethernet-switching {
                storm-control default;
              }
            }
          }
        }
        {% endif %}
        {% endfor %}
      EOT
    },
  ]
}
