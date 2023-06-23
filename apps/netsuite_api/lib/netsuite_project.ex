defmodule NetsuiteApi.Project do
  @moduledoc """
  This is used to describe a Netsuite project with Ecto Schemas
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    netsuite_project_id
    actualtime
    allowallresourcesfortasks
    allowexpenses
    allowtime
    altname
    calculatedenddate
    comments
    companyname
    cseg_bb_project
    customer
    datecreated
    entityid
    entitynumber
    entitytitle
    estimatedgrossprofit
    estimatedlaborcost
    estimatedlaborrevenue
    estimatedtime
    estimatedtimeoverride
    files
    includecrmtasksintotals
    isexempttime
    isinactive
    isproductivetime
    isutilizedtime
    lastmodifieddate
    limittimetoassignees
    links
    materializetime
    parent
    percenttimecomplete
    startdate
    timeapproval
    timeremaining
    custentitysk_update_hubspot_deal
    custentitybb_change_of_scope_comments
    custentity2
    custentity_bb_on_hold_reason
    custentity_ss_customer_class
    custentity_skyline_bludoc_create
    custentity_skl_hubspot_id
    custentity_skl_hs_updatedidtodeal
    custentity_skl_hs_dealid
    custentity_skl_currentmilestone
    custentity_sk_xcel_premise_number
    custentity_sk_utility_account_number
    custentity_sk_utility_account_name
    custentity_sk_upsized_inverter
    custentity_sk_trenching_length
    custentity_sk_trenching_ground_type
    custentity_sk_tree_trimming
    custentity_sk_smart_thermostat
    custentity_sk_site_survey_date
    custentity_sk_second_inverter_model
    custentity_sk_sales_rep
    custentity_sk_roof_repairs
    custentity_sk_roof_reinforcement
    custentity_sk_roof_pitch
    custentity_sk_referred_by
    custentity_sk_proposal_link
    custentity_sk_primary_language
    custentity_sk_premium_panels
    custentity_sk_permit_number
    custentity_sk_panel_skirts
    custentity_sk_number_of_arrays
    custentity_sk_nps_score
    custentity_sk_nma_number
    custentity_sk_module_size
    custentity_sk_module_model
    custentity_sk_meter_upgrade
    custentity_sk_meter_combine
    custentity_sk_main_panel_upgrade
    custentity_sk_led
    custentity_sk_inverter_model
    custentity_sk_interest_rate
    custentity_sk_hoi_received
    custentity_sk_finance_term_length
    custentity_sk_extended_product
    custentity_sk_extended_invertery_warrant
    custentity_sk_ev_charger
    custentity_sk_derate_breaker
    custentity_sk_critter_guard
    custentity_sk_closing_customer_notes
    custentity_sk_cash_back
    custentity_sk_battery_model
    custentity_sk_array_type
    custentity_inv_enrg_consmptn_src_lst
    custentity_bludocs_gdrive_viewer
    custentity_bbss_configuration
    custentity_bb_zoning_text
    custentity_bb_wrnty_pay_comments_text
    custentity_bb_wrnty_expiration_date
    custentity_bb_warranty_service_amount
    custentity_bb_warranty_reserve_amount
    custentity_bb_warranty_inventory_amount
    custentity_bb_warranty_comments_text
    custentity_bb_utility_zone
    custentity_bb_utility_rate_schedule
    custentity_bb_utility_monthly_avg_dec
    custentity_bb_utility_company
    custentity_bb_uses_proj_actn_tran_schdl
    custentity_bb_tran_comments_text
    custentity_bb_total_project_ar_amount
    custentity_bb_total_dealer_fee_amount
    custentity_bb_total_contract_value_amt
    custentity_bb_tot_contract_value_cpy_amt
    custentity_bb_tot_con_value_per_watt_amt
    custentity_bb_timezone
    custentity_bb_tilt_degrees_num
    custentity_bb_system_size_decimal
    custentity_bb_subst_compl_status_txt
    custentity_bb_subst_compl_pack_start_dt
    custentity_bb_subst_compl_pack_end_dt
    custentity_bb_subst_compl_pack_dur_num
    custentity_bb_subst_compl_pack_comments
    custentity_bb_subst_compl_pack_comm_hist
    custentity_bb_subst_compl_last_mod_dt
    custentity_bb_subinstl_vend_credit_total
    custentity_bb_subinstl_vend_bill_total
    custentity_bb_struct_const_mat_type
    custentity_bb_stories_num
    custentity_bb_started_from_proj_template
    custentity_bb_ss_solaredge_site_id
    custentity_bb_ss_sales_tax_account
    custentity_bb_ss_powerfactors_site_id
    custentity_bb_ss_org_already_billed_amt
    custentity_bb_ss_invoice_day
    custentity_bb_ss_inst_already_billed_amt
    custentity_bb_ss_alsoenergy_site_id
    custentity_bb_ss_already_invoiced_amount
    custentity_bb_ss_all_pa_files
    custentity_bb_ss_accrual_journal
    custentity_bb_sq_foot_num
    custentity_bb_spouse_name
    custentity_bb_solar_portion_contract_amt
    custentity_bb_snap_shot_pay_roll_period
    custentity_bb_site_audit_vendor
    custentity_bb_site_audit_scheduled_date
    custentity_bb_site_audit_payment_comment
    custentity_bb_site_audit_pack_status_txt
    custentity_bb_site_audit_pack_start_date
    custentity_bb_site_audit_pack_last_date
    custentity_bb_site_audit_pack_end_date
    custentity_bb_site_audit_pack_dur_num
    custentity_bb_site_audit_pack_comments
    custentity_bb_site_audit_pack_comm_hist
    custentity_bb_site_audit_contact_email
    custentity_bb_site_audit_amount
    custentity_bb_shipping_amount
    custentity_bb_ship_zip_text
    custentity_bb_ship_state
    custentity_bb_ship_city_text
    custentity_bb_ship_address_2_text
    custentity_bb_ship_address_1_text
    custentity_bb_services_costs_pr_watt_amt
    custentity_bb_services_costs_amount
    custentity_bb_sep_kwh_integer
    custentity_bb_second_inverter_qty_num
    custentity_bb_second_inverter_item
    custentity_bb_second_inverter_desc_text
    custentity_bb_sales_tax_amount
    custentity_bb_sales_rep_employee
    custentity_bb_sales_rep_email
    custentity_bb_sales_rep_comm_amt
    custentity_bb_sales_rep_comm_amt_overrid
    custentity_bb_sales_partner_pay_schedule
    custentity_bb_sales_cost_p_watt_amount
    custentity_bb_sales_cost_amount
    custentity_bb_roof_type
    custentity_bb_roof_structure_type
    custentity_bb_roof_material_type
    custentity_bb_rma_comments_text
    custentity_bb_rma_amount
    custentity_bb_revenue_per_watt_amount
    custentity_bb_revenue_amount
    custentity_bb_requires_hoa_application
    custentity_bb_require_call_ahead
    custentity_bb_requested_delivery_date
    custentity_bb_recent_seller_text
    custentity_bb_recent_buyer_text
    custentity_bb_rebate_variance_amount
    custentity_bb_rebate_package_status_text
    custentity_bb_rebate_package_start_date
    custentity_bb_rebate_package_last_mod_dt
    custentity_bb_rebate_package_end_date
    custentity_bb_rebate_package_comments
    custentity_bb_rebate_pack_duration_num
    custentity_bb_rebate_pack_comm_history
    custentity_bb_rebate_included_yes_no
    custentity_bb_rebate_customer
    custentity_bb_rebate_confirmation_amount
    custentity_bb_rebate_conf_amount_copy
    custentity_bb_rebate_assignee
    custentity_bb_rebate_assignee_copy_text
    custentity_bb_rebate_application_amount
    custentity_bb_rebate_app_amount_copy
    custentity_bb_pv_production_meter_url
    custentity_bb_pv_production_meter_item
    custentity_bb_pv_prod_meter_id_text
    custentity_bb_proposal_generated_date
    custentity_bb_property_feet_decimal
    custentity_bb_prop_type
    custentity_bb_project_sub_stage_text
    custentity_bb_project_status
    custentity_bb_project_start_date
    custentity_bb_project_stage_text
    custentity_bb_project_so
    custentity_bb_project_serial_number_text
    custentity_bb_project_program_type
    custentity_bb_project_partner
    custentity_bb_project_manager_employee
    custentity_bb_project_location
    custentity_bb_project_acctg_method
    custentity_bb_proj_install_type
    custentity_bb_proj_install_dates_html
    custentity_bb_proj_inspection_dates_html
    custentity_bb_proj_inc_stmnt
    custentity_bb_proj_home_type
    custentity_bb_proj_google_maps_zoom
    custentity_bb_proj_fin_accpt_dates_html
    custentity_bb_proj_design_dates_html
    custentity_bb_proj_dates_html
    custentity_bb_proj_cac_dates_html
    custentity_bb_proj_bal_sheet
    custentity_bb_proj_address_text
    custentity_bb_price_per_kwh_amount
    custentity_bb_prefers_site_audit_as_addr
    custentity_bb_prefers_design_amt_as_addr
    custentity_bb_pay_on_hold_user
    custentity_bb_paid_comm_amount
    custentity_bb_owner_verification_text
    custentity_bb_originator_vendor
    custentity_bb_originator_pymt_memo_html
    custentity_bb_originator_per_watt_amt
    custentity_bb_originator_pay_memo_html
    custentity_bb_originator_email
    custentity_bb_originator_base_p_watt_amt
    custentity_bb_originator_base_amt
    custentity_bb_orig_vend_credit_total
    custentity_bb_orig_vend_bill_total
    custentity_bb_orig_tot_vendor_bill_amt
    custentity_bb_orig_payout_total
    custentity_bb_orig_payments_on_hold_bool
    custentity_bb_orig_payment_on_hold_date
    custentity_bb_orig_pay_total_overide_amt
    custentity_bb_orig_override_user
    custentity_bb_orig_override_date
    custentity_bb_orig_override_boolean
    custentity_bb_orgntr_per_watt_adder_amt
    custentity_bb_orgntr_per_mod_adder_amt
    custentity_bb_orgntr_per_ft_addr_ttl_amt
    custentity_bb_orgntr_payment_tot_amt
    custentity_bb_orgntr_pay_tot_p_w_amt
    custentity_bb_orgntr_m7_vbill_perc
    custentity_bb_orgntr_m7_vbill_amt
    custentity_bb_orgntr_m6_vbill_perc
    custentity_bb_orgntr_m6_vbill_amt
    custentity_bb_orgntr_m5_vbill_perc
    custentity_bb_orgntr_m5_vbill_amt
    custentity_bb_orgntr_m4_vbill_perc
    custentity_bb_orgntr_m4_vbill_amt
    custentity_bb_orgntr_m3_vbill_perc
    custentity_bb_orgntr_m3_vbill_amt
    custentity_bb_orgntr_m2_vbill_perc
    custentity_bb_orgntr_m2_vbill_amt
    custentity_bb_orgntr_m1_vbill_perc
    custentity_bb_orgntr_m1_vbill_amt
    custentity_bb_orgntr_m0_vbill_perc
    custentity_bb_orgntr_m0_vbill_amt
    custentity_bb_orgntr_fxd_addr_ttl_amt
    custentity_bb_orgntr_addr_ttl_p_watt_amt
    custentity_bb_orgntr_addr_ttl_amt
    custentity_bb_oct_kwh_integer
    custentity_bb_ob_project_uuid
    custentity_bb_nov_kwh_integer
    custentity_bb_net_price_per_watt
    custentity_bb_mounting_type
    custentity_bb_months_in_contract_num
    custentity_bb_module_quantity_num
    custentity_bb_module_item
    custentity_bb_module_install_doc
    custentity_bb_module_description_text
    custentity_bb_middle_name
    custentity_bb_medeek_snow_load
    custentity_bb_medeek_716_wind_risk_i
    custentity_bb_may_kwh_integer
    custentity_bb_marketing_campaign
    custentity_bb_market_value_num
    custentity_bb_market_segment
    custentity_bb_mar_kwh_integer
    custentity_bb_manual_paid_comm_amount
    custentity_bb_m7_sub_install_date
    custentity_bb_m7_sub_install_action
    custentity_bb_m7_origination_date
    custentity_bb_m7_origination_action
    custentity_bb_m7_finance_action
    custentity_bb_m7_dealer_fee_amount
    custentity_bb_m7_date
    custentity_bb_m6_sub_install_date
    custentity_bb_m6_sub_install_action
    custentity_bb_m6_origination_date
    custentity_bb_m6_origination_action
    custentity_bb_m6_finance_action
    custentity_bb_m6_dealer_fee_amount
    custentity_bb_m6_date
    custentity_bb_m5_sub_install_date
    custentity_bb_m5_sub_install_action
    custentity_bb_m5_origination_date
    custentity_bb_m5_origination_action
    custentity_bb_m5_finance_action
    custentity_bb_m5_dealer_fee_amount
    custentity_bb_m5_date
    custentity_bb_m4_sub_install_date
    custentity_bb_m4_sub_install_action
    custentity_bb_m4_origination_date
    custentity_bb_m4_origination_action
    custentity_bb_m4_finance_action
    custentity_bb_m4_dealer_fee_amount
    custentity_bb_m4_date
    custentity_bb_m3_sub_install_date
    custentity_bb_m3_sub_install_action
    custentity_bb_m3_origination_date
    custentity_bb_m3_origination_action
    custentity_bb_m3_finance_action
    custentity_bb_m3_dealer_fee_amount
    custentity_bb_m3_date
    custentity_bb_m2_sub_install_date
    custentity_bb_m2_sub_install_action
    custentity_bb_m2_origination_date
    custentity_bb_m2_origination_action
    custentity_bb_m2_finance_action
    custentity_bb_m2_dealer_fee_amount
    custentity_bb_m2_date
    custentity_bb_m1_sub_install_date
    custentity_bb_m1_sub_install_action
    custentity_bb_m1_origination_date
    custentity_bb_m1_origination_action
    custentity_bb_m1_finance_action
    custentity_bb_m1_dealer_fee_amount
    custentity_bb_m1_date
    custentity_bb_m0_sub_install_date
    custentity_bb_m0_sub_install_action
    custentity_bb_m0_origination_date
    custentity_bb_m0_origination_action
    custentity_bb_m0_finance_action
    custentity_bb_m0_dealer_fee_amount
    custentity_bb_m0_date
    custentity_bb_lot_size_num
    custentity_bb_loan_id_text
    custentity_bb_lead_vendor
    custentity_bb_lead_start_date
    custentity_bb_last_name
    custentity_bb_jun_kwh_integer
    custentity_bb_jul_kwh_integer
    custentity_bb_jan_kwh_integer
    custentity_bb_is_vendor_owned_inverter
    custentity_bb_is_residential_delivery
    custentity_bb_is_project_template
    custentity_bb_is_occupied
    custentity_bb_inverter_quantity_num
    custentity_bb_inverter_item
    custentity_bb_inverter_description_text
    custentity_bb_inverter_comments_text
    custentity_bb_inventory_amount
    custentity_bb_instllr_pr_wt_addr_ttl_amt
    custentity_bb_instllr_pr_md_addr_ttl_amt
    custentity_bb_installr_p_ft_addr_ttl_amt
    custentity_bb_installer_vbill_ttl_amt
    custentity_bb_installer_total_pay_amt
    custentity_bb_installer_price_p_w
    custentity_bb_installer_pay_memo_html
    custentity_bb_installer_partner_vendor
    custentity_bb_installer_main_conct_email
    custentity_bb_installer_m7_vbill_perc
    custentity_bb_installer_m7_vbill_amt
    custentity_bb_installer_m6_vbill_perc
    custentity_bb_installer_m6_vbill_amt
    custentity_bb_installer_m5_vbill_perc
    custentity_bb_installer_m5_vbill_amt
    custentity_bb_installer_m4_vbill_perc
    custentity_bb_installer_m4_vbill_amt
    custentity_bb_installer_m3_vbill_perc
    custentity_bb_installer_m3_vbill_amt
    custentity_bb_installer_m2_vbill_perc
    custentity_bb_installer_m2_vbill_amt
    custentity_bb_installer_m1_vbill_perc
    custentity_bb_installer_m1_vbill_amt
    custentity_bb_installer_m0_vbill_perc
    custentity_bb_installer_m0_vbill_amt
    custentity_bb_installer_fxd_addr_ttl_amt
    custentity_bb_installer_amt
    custentity_bb_installer_adder_total_amt
    custentity_bb_install_zip_code_text
    custentity_bb_install_total_payment_p_w
    custentity_bb_install_state
    custentity_bb_install_scheduled_date
    custentity_bb_install_payout_total
    custentity_bb_install_pay_total_ovrd_amt
    custentity_bb_install_part_pay_schedule
    custentity_bb_install_comp_pack_stat_txt
    custentity_bb_install_comp_pack_start_dt
    custentity_bb_install_comp_pack_last_dt
    custentity_bb_install_comp_pack_end_date
    custentity_bb_install_comp_pack_dur_num
    custentity_bb_install_comp_pack_date
    custentity_bb_install_comp_pack_comments
    custentity_bb_install_comp_pack_comm_his
    custentity_bb_install_comp_deadline_date
    custentity_bb_install_city_text
    custentity_bb_install_address_2_text
    custentity_bb_install_address_1_text
    custentity_bb_install_adder_tot_p_w_amt
    custentity_bb_inspection_partner_vendor
    custentity_bb_inspection_main_cont_email
    custentity_bb_inspection_amount
    custentity_bb_inspect_pay_comments_text
    custentity_bb_homeowner_finance_method
    custentity_bb_homeowner_customer
    custentity_bb_homeowner_association
    custentity_bb_home_owner_primary_email
    custentity_bb_home_owner_phone
    custentity_bb_home_owner_name_text
    custentity_bb_home_owner_alt_email
    custentity_bb_hoa_zip_text
    custentity_bb_hoa_turn_around
    custentity_bb_hoa_review_time_text
    custentity_bb_hoa_phone
    custentity_bb_hoa_package_status_text
    custentity_bb_hoa_package_start_date
    custentity_bb_hoa_package_last_mod_date
    custentity_bb_hoa_package_end_date
    custentity_bb_hoa_package_comments
    custentity_bb_hoa_package_comm_history
    custentity_bb_hoa_pack_duration_num
    custentity_bb_hoa_name_text
    custentity_bb_hoa_email
    custentity_bb_hoa_deposit_status_text
    custentity_bb_ho_credit_approval_date
    custentity_bb_ho_contacted_site_audit_dt
    custentity_bb_has_lift_gate
    custentity_bb_gross_trading_profit_amt
    custentity_bb_gross_profit_percent
    custentity_bb_gross_profit_amount
    custentity_bb_gross_adder_total
    custentity_bb_google_maps_api_key
    custentity_bb_gen_rebate_on_milestone
    custentity_bb_foundation_type
    custentity_bb_forecasted_install_date
    custentity_bb_forecasted_close_date
    custentity_bb_forecast_type
    custentity_bb_forecast_site_survey_date
    custentity_bb_forecast_pto_date
    custentity_bb_forecast_permit_date
    custentity_bb_forecast_inspection_date
    custentity_bb_forecast_design_date
    custentity_bb_first_name
    custentity_bb_fincancer_email
    custentity_bb_financing_type
    custentity_bb_financier_stips_comment
    custentity_bb_financier_payment_schedule
    custentity_bb_financier_loan_url
    custentity_bb_financier_customer
    custentity_bb_financier_adv_pmt_schedule
    custentity_bb_final_completion_date
    custentity_bb_final_acc_pack_status_text
    custentity_bb_final_acc_pack_start_date
    custentity_bb_final_acc_pack_last_mod_dt
    custentity_bb_final_acc_pack_end_date
    custentity_bb_final_acc_pack_comments
    custentity_bb_final_acc_pack_com_history
    custentity_bb_fin_total_invoice_amount
    custentity_bb_fin_total_fees_amount
    custentity_bb_fin_rebate_inv_amount
    custentity_bb_fin_pur_price_p_watt_amt
    custentity_bb_fin_proposal_id_text
    custentity_bb_fin_prelim_purch_price_amt
    custentity_bb_fin_per_watt_adder_amt
    custentity_bb_fin_per_module_adder_amt
    custentity_bb_fin_per_foot_adder_amt
    custentity_bb_fin_payment_memo_html
    custentity_bb_fin_owned_equip_costs_amt
    custentity_bb_fin_orig_per_watt_amt
    custentity_bb_fin_orig_base_per_watt_amt
    custentity_bb_fin_orig_base_amt
    custentity_bb_fin_monitoring_fee_amount
    custentity_bb_fin_m7_invoice_percent
    custentity_bb_fin_m7_invoice_amount
    custentity_bb_fin_m6_invoice_percent
    custentity_bb_fin_m6_invoice_amount
    custentity_bb_fin_m5_invoice_percent
    custentity_bb_fin_m5_invoice_amount
    custentity_bb_fin_m4_invoice_percent
    custentity_bb_fin_m4_invoice_amount
    custentity_bb_fin_m3_invoice_percent
    custentity_bb_fin_m3_invoice_amount
    custentity_bb_fin_m2_invoice_percent
    custentity_bb_fin_m2_invoice_amount
    custentity_bb_fin_m1_invoice_percent
    custentity_bb_fin_m1_invoice_amount
    custentity_bb_fin_m0_invoice_percent
    custentity_bb_fin_m0_invoice_amount
    custentity_bb_fin_install_per_watt_amt
    custentity_bb_fin_install_base_amt
    custentity_bb_fin_fixed_adder_amt
    custentity_bb_fin_customer_id_text
    custentity_bb_fin_base_fees_amount
    custentity_bb_feb_kwh_integer
    custentity_bb_fa_pack_duration_num
    custentity_bb_estimated_annual_kwh_dec
    custentity_bb_est_annual_savings_amt
    custentity_bb_equipment_disposition
    custentity_bb_equip_tran_comments_text
    custentity_bb_equip_shipping_apprvl_date
    custentity_bb_equip_shipping_approval
    custentity_bb_equip_ship_contact_txt
    custentity_bb_equip_cost_per_watt_amount
    custentity_bb_equip_cost_amount
    custentity_bb_epc_role
    custentity_bb_entity_property_link
    custentity_bb_entity_property_image
    custentity_bb_entity_longitude_text
    custentity_bb_entity_latitude_text
    custentity_bb_energy_rate_type
    custentity_bb_energy_rate_schedule
    custentity_bb_energy_production_source
    custentity_bb_down_payment_all_milestone
    custentity_bb_difference_approver
    custentity_bb_difference_approved_date
    custentity_bb_design_payment_comments
    custentity_bb_design_partner_vendor
    custentity_bb_design_package_start_date
    custentity_bb_design_package_end_date
    custentity_bb_design_package_comments
    custentity_bb_design_pack_status_text
    custentity_bb_design_pack_last_mod_date
    custentity_bb_design_pack_duration_num
    custentity_bb_design_pack_comm_history
    custentity_bb_design_main_contact_email
    custentity_bb_design_amount
    custentity_bb_dedct_rebate_all_milestone
    custentity_bb_dec_kwh_integer
    custentity_bb_dealer_fee_percent
    custentity_bb_dealer_fee_app_method
    custentity_bb_datatree_hoa_name_text
    custentity_bb_customer_signture_date
    custentity_bb_customer_category
    custentity_bb_cust_record_link
    custentity_bb_credit_initiated_date
    custentity_bb_copy_to
    custentity_bb_copy_from
    custentity_bb_contract_value_hist_html
    custentity_bb_contract_pack_status_text
    custentity_bb_contract_pack_start_date
    custentity_bb_contract_pack_last_mod_dt
    custentity_bb_contract_pack_end_date
    custentity_bb_contract_pack_dur_num
    custentity_bb_contract_pack_comments
    custentity_bb_contract_pack_comm_history
    custentity_bb_comm_snap_shot_record
    custentity_bb_comm_history_notes
    custentity_bb_comm_difference_approved
    custentity_bb_change_of_scope_reason
    custentity_bb_change_of_scope_date
    custentity_bb_cancellation_reason
    custentity_bb_cancellation_reason_comm
    custentity_bb_cancellation_date
    custentity_bb_call_ahead_phone
    custentity_bb_cac_resigned_date
    custentity_bb_cac_deadline_date
    custentity_bb_built_year_num
    custentity_bb_bom_status_list
    custentity_bb_bom_printed_date
    custentity_bb_bom_edited
    custentity_bb_bodhi_project_id_text
    custentity_bb_battery
    custentity_bb_battery_quantity
    custentity_bb_azimuth_degrees_num
    custentity_bb_avg_utilitybill_month_amt
    custentity_bb_auth_having_jurisdiction
    custentity_bb_aug_kwh_integer
    custentity_bb_assessor_parcel_num
    custentity_bb_apr_kwh_integer
    custentity_bb_alt_phone
    custentity_bb_adv_payment_schdl_tot_amt
    custentity_bb_adv_payment_schdl_percent
    custentity_bb_adv_payment_schdl_count
    custentity_bb_actual_equipment_ship_date
    custentity_bb_act_wrnty_total_amount
    custentity_bb_accrual_je_created_date
    custentity_actgrp_8_status
    custentity_actgrp_8_start_date
    custentity_actgrp_8_last_mod_date
    custentity_actgrp_8_end_date
    custentity_actgrp_8_duration
    custentity_actgrp_8_comments
    custentity_actgrp_8_comment_history
    custentity_actgrp_5_status
    custentity_actgrp_5_start_date
    custentity_actgrp_5_last_mod_date
    custentity_actgrp_5_end_date
    custentity_actgrp_5_duration
    custentity_actgrp_5_comments
    custentity_actgrp_5_comment_history
    custentity_actgrp_136_status
    custentity_actgrp_136_start_date
    custentity_actgrp_136_last_mod_date
    custentity_actgrp_136_end_date
    custentity_actgrp_136_duration
    custentity_actgrp_136_comments
    custentity_actgrp_136_comment_history
    custentity_actgrp_133_status
    custentity_actgrp_133_start_date
    custentity_actgrp_133_last_mod_date
    custentity_actgrp_133_end_date
    custentity_actgrp_133_duration
    custentity_actgrp_133_comments
    custentity_actgrp_133_comment_history
    custentity_actgrp_119_status
    custentity_actgrp_119_start_date
    custentity_actgrp_119_last_mod_date
    custentity_actgrp_119_end_date
    custentity_actgrp_119_duration
    custentity_actgrp_119_comments
    custentity_actgrp_119_comment_history
    custentity_actgrp_11_status
    custentity_actgrp_11_start_date
    custentity_actgrp_11_last_mod_date
    custentity_actgrp_11_end_date
    custentity_actgrp_11_duration
    custentity_actgrp_11_comments
    custentity_actgrp_11_comment_history
    custentity_skl_on_hold_comment
    custentity_skl_hs_net_revenue
    custentity_skl_hs_dealer_fee
    custentity_bb_warehouse_location
    custentity_skl_auto_created_nma_document
    custentity_skl_inverter_size
    custentity_skl_sales_adders
    custentity_skl_sales_promises
  )a

  schema "netsuite_projects" do
    field(:netsuite_project_id, :integer)
    field(:actualtime, :string)
    field(:allowallresourcesfortasks, :string)
    field(:allowexpenses, :string)
    field(:allowtime, :string)
    field(:altname, :string)
    field(:calculatedenddate, :string)
    field(:comments, :string)
    field(:companyname, :string)
    field(:cseg_bb_project, :string)
    field(:customer, :string)
    field(:datecreated, :string)
    field(:entityid, :string)
    field(:entitynumber, :string)
    field(:entitytitle, :string)
    field(:estimatedgrossprofit, :string)
    field(:estimatedlaborcost, :string)
    field(:estimatedlaborrevenue, :string)
    field(:estimatedtime, :string)
    field(:estimatedtimeoverride, :string)
    field(:files, :string)
    field(:includecrmtasksintotals, :string)
    field(:isexempttime, :string)
    field(:isinactive, :string)
    field(:isproductivetime, :string)
    field(:isutilizedtime, :string)
    field(:lastmodifieddate, :string)
    field(:limittimetoassignees, :string)
    field(:links, {:array, :string})
    field(:materializetime, :string)
    field(:parent, :string)
    field(:percenttimecomplete, :string)
    field(:startdate, :string)
    field(:timeapproval, :string)
    field(:timeremaining, :string)
    field(:custentitysk_update_hubspot_deal, :string)
    field(:custentitybb_change_of_scope_comments, :string)
    field(:custentity2, :string)
    field(:custentity_bb_on_hold_reason, :string)
    field(:custentity_ss_customer_class, :string)
    field(:custentity_skyline_bludoc_create, :string)
    field(:custentity_skl_hubspot_id, :integer)
    field(:custentity_skl_hs_updatedidtodeal, :string)
    field(:custentity_skl_hs_dealid, :integer)
    field(:custentity_skl_currentmilestone, :string)
    field(:custentity_sk_xcel_premise_number, :string)
    field(:custentity_sk_utility_account_number, :string)
    field(:custentity_sk_utility_account_name, :string)
    field(:custentity_sk_upsized_inverter, :string)
    field(:custentity_sk_trenching_length, :string)
    field(:custentity_sk_trenching_ground_type, :string)
    field(:custentity_sk_tree_trimming, :string)
    field(:custentity_sk_smart_thermostat, :string)
    field(:custentity_sk_site_survey_date, :string)
    field(:custentity_sk_second_inverter_model, :string)
    field(:custentity_sk_sales_rep, :string)
    field(:custentity_sk_roof_repairs, :string)
    field(:custentity_sk_roof_reinforcement, :string)
    field(:custentity_sk_roof_pitch, :string)
    field(:custentity_sk_referred_by, :string)
    field(:custentity_sk_proposal_link, :string)
    field(:custentity_sk_primary_language, :string)
    field(:custentity_sk_premium_panels, :string)
    field(:custentity_sk_permit_number, :string)
    field(:custentity_sk_panel_skirts, :string)
    field(:custentity_sk_number_of_arrays, :string)
    field(:custentity_sk_nps_score, :string)
    field(:custentity_sk_nma_number, :string)
    field(:custentity_sk_module_size, :string)
    field(:custentity_sk_module_model, :string)
    field(:custentity_sk_meter_upgrade, :string)
    field(:custentity_sk_meter_combine, :string)
    field(:custentity_sk_main_panel_upgrade, :string)
    field(:custentity_sk_led, :string)
    field(:custentity_sk_inverter_model, :string)
    field(:custentity_sk_interest_rate, :string)
    field(:custentity_sk_hoi_received, :string)
    field(:custentity_sk_finance_term_length, :string)
    field(:custentity_sk_extended_product, :string)
    field(:custentity_sk_extended_invertery_warrant, :string)
    field(:custentity_sk_ev_charger, :string)
    field(:custentity_sk_derate_breaker, :string)
    field(:custentity_sk_critter_guard, :string)
    field(:custentity_sk_closing_customer_notes, :string)
    field(:custentity_sk_cash_back, :string)
    field(:custentity_sk_battery_model, :string)
    field(:custentity_sk_array_type, :string)
    field(:custentity_inv_enrg_consmptn_src_lst, :string)
    field(:custentity_bludocs_gdrive_viewer, :string)
    field(:custentity_bbss_configuration, :string)
    field(:custentity_bb_zoning_text, :string)
    field(:custentity_bb_wrnty_pay_comments_text, :string)
    field(:custentity_bb_wrnty_expiration_date, :string)
    field(:custentity_bb_warranty_service_amount, :string)
    field(:custentity_bb_warranty_reserve_amount, :string)
    field(:custentity_bb_warranty_inventory_amount, :string)
    field(:custentity_bb_warranty_comments_text, :string)
    field(:custentity_bb_utility_zone, :string)
    field(:custentity_bb_utility_rate_schedule, :string)
    field(:custentity_bb_utility_monthly_avg_dec, :string)
    field(:custentity_bb_utility_company, :string)
    field(:custentity_bb_uses_proj_actn_tran_schdl, :string)
    field(:custentity_bb_tran_comments_text, :string)
    field(:custentity_bb_total_project_ar_amount, :string)
    field(:custentity_bb_total_dealer_fee_amount, :string)
    field(:custentity_bb_total_contract_value_amt, :string)
    field(:custentity_bb_tot_contract_value_cpy_amt, :string)
    field(:custentity_bb_tot_con_value_per_watt_amt, :string)
    field(:custentity_bb_timezone, :string)
    field(:custentity_bb_tilt_degrees_num, :string)
    field(:custentity_bb_system_size_decimal, :string)
    field(:custentity_bb_subst_compl_status_txt, :string)
    field(:custentity_bb_subst_compl_pack_start_dt, :string)
    field(:custentity_bb_subst_compl_pack_end_dt, :string)
    field(:custentity_bb_subst_compl_pack_dur_num, :string)
    field(:custentity_bb_subst_compl_pack_comments, :string)
    field(:custentity_bb_subst_compl_pack_comm_hist, :string)
    field(:custentity_bb_subst_compl_last_mod_dt, :string)
    field(:custentity_bb_subinstl_vend_credit_total, :string)
    field(:custentity_bb_subinstl_vend_bill_total, :string)
    field(:custentity_bb_struct_const_mat_type, :string)
    field(:custentity_bb_stories_num, :string)
    field(:custentity_bb_started_from_proj_template, :string)
    field(:custentity_bb_ss_solaredge_site_id, :string)
    field(:custentity_bb_ss_sales_tax_account, :string)
    field(:custentity_bb_ss_powerfactors_site_id, :string)
    field(:custentity_bb_ss_org_already_billed_amt, :string)
    field(:custentity_bb_ss_invoice_day, :string)
    field(:custentity_bb_ss_inst_already_billed_amt, :string)
    field(:custentity_bb_ss_alsoenergy_site_id, :string)
    field(:custentity_bb_ss_already_invoiced_amount, :string)
    field(:custentity_bb_ss_all_pa_files, :string)
    field(:custentity_bb_ss_accrual_journal, :string)
    field(:custentity_bb_sq_foot_num, :string)
    field(:custentity_bb_spouse_name, :string)
    field(:custentity_bb_solar_portion_contract_amt, :string)
    field(:custentity_bb_snap_shot_pay_roll_period, :string)
    field(:custentity_bb_site_audit_vendor, :string)
    field(:custentity_bb_site_audit_scheduled_date, :string)
    field(:custentity_bb_site_audit_payment_comment, :string)
    field(:custentity_bb_site_audit_pack_status_txt, :string)
    field(:custentity_bb_site_audit_pack_start_date, :string)
    field(:custentity_bb_site_audit_pack_last_date, :string)
    field(:custentity_bb_site_audit_pack_end_date, :string)
    field(:custentity_bb_site_audit_pack_dur_num, :string)
    field(:custentity_bb_site_audit_pack_comments, :string)
    field(:custentity_bb_site_audit_pack_comm_hist, :string)
    field(:custentity_bb_site_audit_contact_email, :string)
    field(:custentity_bb_site_audit_amount, :string)
    field(:custentity_bb_shipping_amount, :string)
    field(:custentity_bb_ship_zip_text, :string)
    field(:custentity_bb_ship_state, :string)
    field(:custentity_bb_ship_city_text, :string)
    field(:custentity_bb_ship_address_2_text, :string)
    field(:custentity_bb_ship_address_1_text, :string)
    field(:custentity_bb_services_costs_pr_watt_amt, :string)
    field(:custentity_bb_services_costs_amount, :string)
    field(:custentity_bb_sep_kwh_integer, :string)
    field(:custentity_bb_second_inverter_qty_num, :string)
    field(:custentity_bb_second_inverter_item, :string)
    field(:custentity_bb_second_inverter_desc_text, :string)
    field(:custentity_bb_sales_tax_amount, :string)
    field(:custentity_bb_sales_rep_employee, :string)
    field(:custentity_bb_sales_rep_email, :string)
    field(:custentity_bb_sales_rep_comm_amt, :string)
    field(:custentity_bb_sales_rep_comm_amt_overrid, :string)
    field(:custentity_bb_sales_partner_pay_schedule, :string)
    field(:custentity_bb_sales_cost_p_watt_amount, :string)
    field(:custentity_bb_sales_cost_amount, :string)
    field(:custentity_bb_roof_type, :string)
    field(:custentity_bb_roof_structure_type, :string)
    field(:custentity_bb_roof_material_type, :string)
    field(:custentity_bb_rma_comments_text, :string)
    field(:custentity_bb_rma_amount, :string)
    field(:custentity_bb_revenue_per_watt_amount, :string)
    field(:custentity_bb_revenue_amount, :string)
    field(:custentity_bb_requires_hoa_application, :string)
    field(:custentity_bb_require_call_ahead, :string)
    field(:custentity_bb_requested_delivery_date, :string)
    field(:custentity_bb_recent_seller_text, :string)
    field(:custentity_bb_recent_buyer_text, :string)
    field(:custentity_bb_rebate_variance_amount, :string)
    field(:custentity_bb_rebate_package_status_text, :string)
    field(:custentity_bb_rebate_package_start_date, :string)
    field(:custentity_bb_rebate_package_last_mod_dt, :string)
    field(:custentity_bb_rebate_package_end_date, :string)
    field(:custentity_bb_rebate_package_comments, :string)
    field(:custentity_bb_rebate_pack_duration_num, :string)
    field(:custentity_bb_rebate_pack_comm_history, :string)
    field(:custentity_bb_rebate_included_yes_no, :string)
    field(:custentity_bb_rebate_customer, :string)
    field(:custentity_bb_rebate_confirmation_amount, :string)
    field(:custentity_bb_rebate_conf_amount_copy, :string)
    field(:custentity_bb_rebate_assignee, :string)
    field(:custentity_bb_rebate_assignee_copy_text, :string)
    field(:custentity_bb_rebate_application_amount, :string)
    field(:custentity_bb_rebate_app_amount_copy, :string)
    field(:custentity_bb_pv_production_meter_url, :string)
    field(:custentity_bb_pv_production_meter_item, :string)
    field(:custentity_bb_pv_prod_meter_id_text, :string)
    field(:custentity_bb_proposal_generated_date, :string)
    field(:custentity_bb_property_feet_decimal, :string)
    field(:custentity_bb_prop_type, :string)
    field(:custentity_bb_project_sub_stage_text, :string)
    field(:custentity_bb_project_status, :string)
    field(:custentity_bb_project_start_date, :string)
    field(:custentity_bb_project_stage_text, :string)
    field(:custentity_bb_project_so, :string)
    field(:custentity_bb_project_serial_number_text, :string)
    field(:custentity_bb_project_program_type, :string)
    field(:custentity_bb_project_partner, :string)
    field(:custentity_bb_project_manager_employee, :string)
    field(:custentity_bb_project_location, :string)
    field(:custentity_bb_project_acctg_method, :string)
    field(:custentity_bb_proj_install_type, :string)
    field(:custentity_bb_proj_install_dates_html, :string)
    field(:custentity_bb_proj_inspection_dates_html, :string)
    field(:custentity_bb_proj_inc_stmnt, :string)
    field(:custentity_bb_proj_home_type, :string)
    field(:custentity_bb_proj_google_maps_zoom, :string)
    field(:custentity_bb_proj_fin_accpt_dates_html, :string)
    field(:custentity_bb_proj_design_dates_html, :string)
    field(:custentity_bb_proj_dates_html, :string)
    field(:custentity_bb_proj_cac_dates_html, :string)
    field(:custentity_bb_proj_bal_sheet, :string)
    field(:custentity_bb_proj_address_text, :string)
    field(:custentity_bb_price_per_kwh_amount, :string)
    field(:custentity_bb_prefers_site_audit_as_addr, :string)
    field(:custentity_bb_prefers_design_amt_as_addr, :string)
    field(:custentity_bb_pay_on_hold_user, :string)
    field(:custentity_bb_paid_comm_amount, :string)
    field(:custentity_bb_owner_verification_text, :string)
    field(:custentity_bb_originator_vendor, :string)
    field(:custentity_bb_originator_pymt_memo_html, :string)
    field(:custentity_bb_originator_per_watt_amt, :string)
    field(:custentity_bb_originator_pay_memo_html, :string)
    field(:custentity_bb_originator_email, :string)
    field(:custentity_bb_originator_base_p_watt_amt, :string)
    field(:custentity_bb_originator_base_amt, :string)
    field(:custentity_bb_orig_vend_credit_total, :string)
    field(:custentity_bb_orig_vend_bill_total, :string)
    field(:custentity_bb_orig_tot_vendor_bill_amt, :string)
    field(:custentity_bb_orig_payout_total, :string)
    field(:custentity_bb_orig_payments_on_hold_bool, :string)
    field(:custentity_bb_orig_payment_on_hold_date, :string)
    field(:custentity_bb_orig_pay_total_overide_amt, :string)
    field(:custentity_bb_orig_override_user, :string)
    field(:custentity_bb_orig_override_date, :string)
    field(:custentity_bb_orig_override_boolean, :string)
    field(:custentity_bb_orgntr_per_watt_adder_amt, :string)
    field(:custentity_bb_orgntr_per_mod_adder_amt, :string)
    field(:custentity_bb_orgntr_per_ft_addr_ttl_amt, :string)
    field(:custentity_bb_orgntr_payment_tot_amt, :string)
    field(:custentity_bb_orgntr_pay_tot_p_w_amt, :string)
    field(:custentity_bb_orgntr_m7_vbill_perc, :string)
    field(:custentity_bb_orgntr_m7_vbill_amt, :string)
    field(:custentity_bb_orgntr_m6_vbill_perc, :string)
    field(:custentity_bb_orgntr_m6_vbill_amt, :string)
    field(:custentity_bb_orgntr_m5_vbill_perc, :string)
    field(:custentity_bb_orgntr_m5_vbill_amt, :string)
    field(:custentity_bb_orgntr_m4_vbill_perc, :string)
    field(:custentity_bb_orgntr_m4_vbill_amt, :string)
    field(:custentity_bb_orgntr_m3_vbill_perc, :string)
    field(:custentity_bb_orgntr_m3_vbill_amt, :string)
    field(:custentity_bb_orgntr_m2_vbill_perc, :string)
    field(:custentity_bb_orgntr_m2_vbill_amt, :string)
    field(:custentity_bb_orgntr_m1_vbill_perc, :string)
    field(:custentity_bb_orgntr_m1_vbill_amt, :string)
    field(:custentity_bb_orgntr_m0_vbill_perc, :string)
    field(:custentity_bb_orgntr_m0_vbill_amt, :string)
    field(:custentity_bb_orgntr_fxd_addr_ttl_amt, :string)
    field(:custentity_bb_orgntr_addr_ttl_p_watt_amt, :string)
    field(:custentity_bb_orgntr_addr_ttl_amt, :string)
    field(:custentity_bb_oct_kwh_integer, :string)
    field(:custentity_bb_ob_project_uuid, :string)
    field(:custentity_bb_nov_kwh_integer, :string)
    field(:custentity_bb_net_price_per_watt, :string)
    field(:custentity_bb_mounting_type, :string)
    field(:custentity_bb_months_in_contract_num, :string)
    field(:custentity_bb_module_quantity_num, :string)
    field(:custentity_bb_module_item, :string)
    field(:custentity_bb_module_install_doc, :string)
    field(:custentity_bb_module_description_text, :string)
    field(:custentity_bb_middle_name, :string)
    field(:custentity_bb_medeek_snow_load, :string)
    field(:custentity_bb_medeek_716_wind_risk_i, :string)
    field(:custentity_bb_may_kwh_integer, :string)
    field(:custentity_bb_marketing_campaign, :string)
    field(:custentity_bb_market_value_num, :string)
    field(:custentity_bb_market_segment, :string)
    field(:custentity_bb_mar_kwh_integer, :string)
    field(:custentity_bb_manual_paid_comm_amount, :string)
    field(:custentity_bb_m7_sub_install_date, :string)
    field(:custentity_bb_m7_sub_install_action, :string)
    field(:custentity_bb_m7_origination_date, :string)
    field(:custentity_bb_m7_origination_action, :string)
    field(:custentity_bb_m7_finance_action, :string)
    field(:custentity_bb_m7_dealer_fee_amount, :string)
    field(:custentity_bb_m7_date, :string)
    field(:custentity_bb_m6_sub_install_date, :string)
    field(:custentity_bb_m6_sub_install_action, :string)
    field(:custentity_bb_m6_origination_date, :string)
    field(:custentity_bb_m6_origination_action, :string)
    field(:custentity_bb_m6_finance_action, :string)
    field(:custentity_bb_m6_dealer_fee_amount, :string)
    field(:custentity_bb_m6_date, :string)
    field(:custentity_bb_m5_sub_install_date, :string)
    field(:custentity_bb_m5_sub_install_action, :string)
    field(:custentity_bb_m5_origination_date, :string)
    field(:custentity_bb_m5_origination_action, :string)
    field(:custentity_bb_m5_finance_action, :string)
    field(:custentity_bb_m5_dealer_fee_amount, :string)
    field(:custentity_bb_m5_date, :string)
    field(:custentity_bb_m4_sub_install_date, :string)
    field(:custentity_bb_m4_sub_install_action, :string)
    field(:custentity_bb_m4_origination_date, :string)
    field(:custentity_bb_m4_origination_action, :string)
    field(:custentity_bb_m4_finance_action, :string)
    field(:custentity_bb_m4_dealer_fee_amount, :string)
    field(:custentity_bb_m4_date, :string)
    field(:custentity_bb_m3_sub_install_date, :string)
    field(:custentity_bb_m3_sub_install_action, :string)
    field(:custentity_bb_m3_origination_date, :string)
    field(:custentity_bb_m3_origination_action, :string)
    field(:custentity_bb_m3_finance_action, :string)
    field(:custentity_bb_m3_dealer_fee_amount, :string)
    field(:custentity_bb_m3_date, :string)
    field(:custentity_bb_m2_sub_install_date, :string)
    field(:custentity_bb_m2_sub_install_action, :string)
    field(:custentity_bb_m2_origination_date, :string)
    field(:custentity_bb_m2_origination_action, :string)
    field(:custentity_bb_m2_finance_action, :string)
    field(:custentity_bb_m2_dealer_fee_amount, :string)
    field(:custentity_bb_m2_date, :string)
    field(:custentity_bb_m1_sub_install_date, :string)
    field(:custentity_bb_m1_sub_install_action, :string)
    field(:custentity_bb_m1_origination_date, :string)
    field(:custentity_bb_m1_origination_action, :string)
    field(:custentity_bb_m1_finance_action, :string)
    field(:custentity_bb_m1_dealer_fee_amount, :string)
    field(:custentity_bb_m1_date, :string)
    field(:custentity_bb_m0_sub_install_date, :string)
    field(:custentity_bb_m0_sub_install_action, :string)
    field(:custentity_bb_m0_origination_date, :string)
    field(:custentity_bb_m0_origination_action, :string)
    field(:custentity_bb_m0_finance_action, :string)
    field(:custentity_bb_m0_dealer_fee_amount, :string)
    field(:custentity_bb_m0_date, :string)
    field(:custentity_bb_lot_size_num, :string)
    field(:custentity_bb_loan_id_text, :string)
    field(:custentity_bb_lead_vendor, :string)
    field(:custentity_bb_lead_start_date, :string)
    field(:custentity_bb_last_name, :string)
    field(:custentity_bb_jun_kwh_integer, :string)
    field(:custentity_bb_jul_kwh_integer, :string)
    field(:custentity_bb_jan_kwh_integer, :string)
    field(:custentity_bb_is_vendor_owned_inverter, :string)
    field(:custentity_bb_is_residential_delivery, :string)
    field(:custentity_bb_is_project_template, :string)
    field(:custentity_bb_is_occupied, :string)
    field(:custentity_bb_inverter_quantity_num, :string)
    field(:custentity_bb_inverter_item, :string)
    field(:custentity_bb_inverter_description_text, :string)
    field(:custentity_bb_inverter_comments_text, :string)
    field(:custentity_bb_inventory_amount, :string)
    field(:custentity_bb_instllr_pr_wt_addr_ttl_amt, :string)
    field(:custentity_bb_instllr_pr_md_addr_ttl_amt, :string)
    field(:custentity_bb_installr_p_ft_addr_ttl_amt, :string)
    field(:custentity_bb_installer_vbill_ttl_amt, :string)
    field(:custentity_bb_installer_total_pay_amt, :string)
    field(:custentity_bb_installer_price_p_w, :string)
    field(:custentity_bb_installer_pay_memo_html, :string)
    field(:custentity_bb_installer_partner_vendor, :string)
    field(:custentity_bb_installer_main_conct_email, :string)
    field(:custentity_bb_installer_m7_vbill_perc, :string)
    field(:custentity_bb_installer_m7_vbill_amt, :string)
    field(:custentity_bb_installer_m6_vbill_perc, :string)
    field(:custentity_bb_installer_m6_vbill_amt, :string)
    field(:custentity_bb_installer_m5_vbill_perc, :string)
    field(:custentity_bb_installer_m5_vbill_amt, :string)
    field(:custentity_bb_installer_m4_vbill_perc, :string)
    field(:custentity_bb_installer_m4_vbill_amt, :string)
    field(:custentity_bb_installer_m3_vbill_perc, :string)
    field(:custentity_bb_installer_m3_vbill_amt, :string)
    field(:custentity_bb_installer_m2_vbill_perc, :string)
    field(:custentity_bb_installer_m2_vbill_amt, :string)
    field(:custentity_bb_installer_m1_vbill_perc, :string)
    field(:custentity_bb_installer_m1_vbill_amt, :string)
    field(:custentity_bb_installer_m0_vbill_perc, :string)
    field(:custentity_bb_installer_m0_vbill_amt, :string)
    field(:custentity_bb_installer_fxd_addr_ttl_amt, :string)
    field(:custentity_bb_installer_amt, :string)
    field(:custentity_bb_installer_adder_total_amt, :string)
    field(:custentity_bb_install_zip_code_text, :string)
    field(:custentity_bb_install_total_payment_p_w, :string)
    field(:custentity_bb_install_state, :string)
    field(:custentity_bb_install_scheduled_date, :string)
    field(:custentity_bb_install_payout_total, :string)
    field(:custentity_bb_install_pay_total_ovrd_amt, :string)
    field(:custentity_bb_install_part_pay_schedule, :string)
    field(:custentity_bb_install_comp_pack_stat_txt, :string)
    field(:custentity_bb_install_comp_pack_start_dt, :string)
    field(:custentity_bb_install_comp_pack_last_dt, :string)
    field(:custentity_bb_install_comp_pack_end_date, :string)
    field(:custentity_bb_install_comp_pack_dur_num, :string)
    field(:custentity_bb_install_comp_pack_date, :string)
    field(:custentity_bb_install_comp_pack_comments, :string)
    field(:custentity_bb_install_comp_pack_comm_his, :string)
    field(:custentity_bb_install_comp_deadline_date, :string)
    field(:custentity_bb_install_city_text, :string)
    field(:custentity_bb_install_address_2_text, :string)
    field(:custentity_bb_install_address_1_text, :string)
    field(:custentity_bb_install_adder_tot_p_w_amt, :string)
    field(:custentity_bb_inspection_partner_vendor, :string)
    field(:custentity_bb_inspection_main_cont_email, :string)
    field(:custentity_bb_inspection_amount, :string)
    field(:custentity_bb_inspect_pay_comments_text, :string)
    field(:custentity_bb_homeowner_finance_method, :string)
    field(:custentity_bb_homeowner_customer, :string)
    field(:custentity_bb_homeowner_association, :string)
    field(:custentity_bb_home_owner_primary_email, :string)
    field(:custentity_bb_home_owner_phone, :string)
    field(:custentity_bb_home_owner_name_text, :string)
    field(:custentity_bb_home_owner_alt_email, :string)
    field(:custentity_bb_hoa_zip_text, :string)
    field(:custentity_bb_hoa_turn_around, :string)
    field(:custentity_bb_hoa_review_time_text, :string)
    field(:custentity_bb_hoa_phone, :string)
    field(:custentity_bb_hoa_package_status_text, :string)
    field(:custentity_bb_hoa_package_start_date, :string)
    field(:custentity_bb_hoa_package_last_mod_date, :string)
    field(:custentity_bb_hoa_package_end_date, :string)
    field(:custentity_bb_hoa_package_comments, :string)
    field(:custentity_bb_hoa_package_comm_history, :string)
    field(:custentity_bb_hoa_pack_duration_num, :string)
    field(:custentity_bb_hoa_name_text, :string)
    field(:custentity_bb_hoa_email, :string)
    field(:custentity_bb_hoa_deposit_status_text, :string)
    field(:custentity_bb_ho_credit_approval_date, :string)
    field(:custentity_bb_ho_contacted_site_audit_dt, :string)
    field(:custentity_bb_has_lift_gate, :string)
    field(:custentity_bb_gross_trading_profit_amt, :string)
    field(:custentity_bb_gross_profit_percent, :string)
    field(:custentity_bb_gross_profit_amount, :string)
    field(:custentity_bb_gross_adder_total, :string)
    field(:custentity_bb_google_maps_api_key, :string)
    field(:custentity_bb_gen_rebate_on_milestone, :string)
    field(:custentity_bb_foundation_type, :string)
    field(:custentity_bb_forecasted_install_date, :string)
    field(:custentity_bb_forecasted_close_date, :string)
    field(:custentity_bb_forecast_type, :string)
    field(:custentity_bb_forecast_site_survey_date, :string)
    field(:custentity_bb_forecast_pto_date, :string)
    field(:custentity_bb_forecast_permit_date, :string)
    field(:custentity_bb_forecast_inspection_date, :string)
    field(:custentity_bb_forecast_design_date, :string)
    field(:custentity_bb_first_name, :string)
    field(:custentity_bb_fincancer_email, :string)
    field(:custentity_bb_financing_type, :string)
    field(:custentity_bb_financier_stips_comment, :string)
    field(:custentity_bb_financier_payment_schedule, :string)
    field(:custentity_bb_financier_loan_url, :string)
    field(:custentity_bb_financier_customer, :string)
    field(:custentity_bb_financier_adv_pmt_schedule, :string)
    field(:custentity_bb_final_completion_date, :string)
    field(:custentity_bb_final_acc_pack_status_text, :string)
    field(:custentity_bb_final_acc_pack_start_date, :string)
    field(:custentity_bb_final_acc_pack_last_mod_dt, :string)
    field(:custentity_bb_final_acc_pack_end_date, :string)
    field(:custentity_bb_final_acc_pack_comments, :string)
    field(:custentity_bb_final_acc_pack_com_history, :string)
    field(:custentity_bb_fin_total_invoice_amount, :string)
    field(:custentity_bb_fin_total_fees_amount, :string)
    field(:custentity_bb_fin_rebate_inv_amount, :string)
    field(:custentity_bb_fin_pur_price_p_watt_amt, :string)
    field(:custentity_bb_fin_proposal_id_text, :string)
    field(:custentity_bb_fin_prelim_purch_price_amt, :string)
    field(:custentity_bb_fin_per_watt_adder_amt, :string)
    field(:custentity_bb_fin_per_module_adder_amt, :string)
    field(:custentity_bb_fin_per_foot_adder_amt, :string)
    field(:custentity_bb_fin_payment_memo_html, :string)
    field(:custentity_bb_fin_owned_equip_costs_amt, :string)
    field(:custentity_bb_fin_orig_per_watt_amt, :string)
    field(:custentity_bb_fin_orig_base_per_watt_amt, :string)
    field(:custentity_bb_fin_orig_base_amt, :string)
    field(:custentity_bb_fin_monitoring_fee_amount, :string)
    field(:custentity_bb_fin_m7_invoice_percent, :string)
    field(:custentity_bb_fin_m7_invoice_amount, :string)
    field(:custentity_bb_fin_m6_invoice_percent, :string)
    field(:custentity_bb_fin_m6_invoice_amount, :string)
    field(:custentity_bb_fin_m5_invoice_percent, :string)
    field(:custentity_bb_fin_m5_invoice_amount, :string)
    field(:custentity_bb_fin_m4_invoice_percent, :string)
    field(:custentity_bb_fin_m4_invoice_amount, :string)
    field(:custentity_bb_fin_m3_invoice_percent, :string)
    field(:custentity_bb_fin_m3_invoice_amount, :string)
    field(:custentity_bb_fin_m2_invoice_percent, :string)
    field(:custentity_bb_fin_m2_invoice_amount, :string)
    field(:custentity_bb_fin_m1_invoice_percent, :string)
    field(:custentity_bb_fin_m1_invoice_amount, :string)
    field(:custentity_bb_fin_m0_invoice_percent, :string)
    field(:custentity_bb_fin_m0_invoice_amount, :string)
    field(:custentity_bb_fin_install_per_watt_amt, :string)
    field(:custentity_bb_fin_install_base_amt, :string)
    field(:custentity_bb_fin_fixed_adder_amt, :string)
    field(:custentity_bb_fin_customer_id_text, :string)
    field(:custentity_bb_fin_base_fees_amount, :string)
    field(:custentity_bb_feb_kwh_integer, :string)
    field(:custentity_bb_fa_pack_duration_num, :string)
    field(:custentity_bb_estimated_annual_kwh_dec, :string)
    field(:custentity_bb_est_annual_savings_amt, :string)
    field(:custentity_bb_equipment_disposition, :string)
    field(:custentity_bb_equip_tran_comments_text, :string)
    field(:custentity_bb_equip_shipping_apprvl_date, :string)
    field(:custentity_bb_equip_shipping_approval, :string)
    field(:custentity_bb_equip_ship_contact_txt, :string)
    field(:custentity_bb_equip_cost_per_watt_amount, :string)
    field(:custentity_bb_equip_cost_amount, :string)
    field(:custentity_bb_epc_role, :string)
    field(:custentity_bb_entity_property_link, :string)
    field(:custentity_bb_entity_property_image, :string)
    field(:custentity_bb_entity_longitude_text, :string)
    field(:custentity_bb_entity_latitude_text, :string)
    field(:custentity_bb_energy_rate_type, :string)
    field(:custentity_bb_energy_rate_schedule, :string)
    field(:custentity_bb_energy_production_source, :string)
    field(:custentity_bb_down_payment_all_milestone, :string)
    field(:custentity_bb_difference_approver, :string)
    field(:custentity_bb_difference_approved_date, :string)
    field(:custentity_bb_design_payment_comments, :string)
    field(:custentity_bb_design_partner_vendor, :string)
    field(:custentity_bb_design_package_start_date, :string)
    field(:custentity_bb_design_package_end_date, :string)
    field(:custentity_bb_design_package_comments, :string)
    field(:custentity_bb_design_pack_status_text, :string)
    field(:custentity_bb_design_pack_last_mod_date, :string)
    field(:custentity_bb_design_pack_duration_num, :string)
    field(:custentity_bb_design_pack_comm_history, :string)
    field(:custentity_bb_design_main_contact_email, :string)
    field(:custentity_bb_design_amount, :string)
    field(:custentity_bb_dedct_rebate_all_milestone, :string)
    field(:custentity_bb_dec_kwh_integer, :string)
    field(:custentity_bb_dealer_fee_percent, :string)
    field(:custentity_bb_dealer_fee_app_method, :string)
    field(:custentity_bb_datatree_hoa_name_text, :string)
    field(:custentity_bb_customer_signture_date, :string)
    field(:custentity_bb_customer_category, :string)
    field(:custentity_bb_cust_record_link, :string)
    field(:custentity_bb_credit_initiated_date, :string)
    field(:custentity_bb_copy_to, :string)
    field(:custentity_bb_copy_from, :string)
    field(:custentity_bb_contract_value_hist_html, :string)
    field(:custentity_bb_contract_pack_status_text, :string)
    field(:custentity_bb_contract_pack_start_date, :string)
    field(:custentity_bb_contract_pack_last_mod_dt, :string)
    field(:custentity_bb_contract_pack_end_date, :string)
    field(:custentity_bb_contract_pack_dur_num, :string)
    field(:custentity_bb_contract_pack_comments, :string)
    field(:custentity_bb_contract_pack_comm_history, :string)
    field(:custentity_bb_comm_snap_shot_record, :string)
    field(:custentity_bb_comm_history_notes, :string)
    field(:custentity_bb_comm_difference_approved, :string)
    field(:custentity_bb_change_of_scope_reason, :string)
    field(:custentity_bb_change_of_scope_date, :string)
    field(:custentity_bb_cancellation_reason, :string)
    field(:custentity_bb_cancellation_reason_comm, :string)
    field(:custentity_bb_cancellation_date, :string)
    field(:custentity_bb_call_ahead_phone, :string)
    field(:custentity_bb_cac_resigned_date, :string)
    field(:custentity_bb_cac_deadline_date, :string)
    field(:custentity_bb_built_year_num, :string)
    field(:custentity_bb_bom_status_list, :string)
    field(:custentity_bb_bom_printed_date, :string)
    field(:custentity_bb_bom_edited, :string)
    field(:custentity_bb_bodhi_project_id_text, :string)
    field(:custentity_bb_battery, :string)
    field(:custentity_bb_battery_quantity, :string)
    field(:custentity_bb_azimuth_degrees_num, :string)
    field(:custentity_bb_avg_utilitybill_month_amt, :string)
    field(:custentity_bb_auth_having_jurisdiction, :string)
    field(:custentity_bb_aug_kwh_integer, :string)
    field(:custentity_bb_assessor_parcel_num, :string)
    field(:custentity_bb_apr_kwh_integer, :string)
    field(:custentity_bb_alt_phone, :string)
    field(:custentity_bb_adv_payment_schdl_tot_amt, :string)
    field(:custentity_bb_adv_payment_schdl_percent, :string)
    field(:custentity_bb_adv_payment_schdl_count, :string)
    field(:custentity_bb_actual_equipment_ship_date, :string)
    field(:custentity_bb_act_wrnty_total_amount, :string)
    field(:custentity_bb_accrual_je_created_date, :string)
    field(:custentity_actgrp_8_status, :string)
    field(:custentity_actgrp_8_start_date, :string)
    field(:custentity_actgrp_8_last_mod_date, :string)
    field(:custentity_actgrp_8_end_date, :string)
    field(:custentity_actgrp_8_duration, :string)
    field(:custentity_actgrp_8_comments, :string)
    field(:custentity_actgrp_8_comment_history, :string)
    field(:custentity_actgrp_5_status, :string)
    field(:custentity_actgrp_5_start_date, :string)
    field(:custentity_actgrp_5_last_mod_date, :string)
    field(:custentity_actgrp_5_end_date, :string)
    field(:custentity_actgrp_5_duration, :string)
    field(:custentity_actgrp_5_comments, :string)
    field(:custentity_actgrp_5_comment_history, :string)
    field(:custentity_actgrp_136_status, :string)
    field(:custentity_actgrp_136_start_date, :string)
    field(:custentity_actgrp_136_last_mod_date, :string)
    field(:custentity_actgrp_136_end_date, :string)
    field(:custentity_actgrp_136_duration, :string)
    field(:custentity_actgrp_136_comments, :string)
    field(:custentity_actgrp_136_comment_history, :string)
    field(:custentity_actgrp_133_status, :string)
    field(:custentity_actgrp_133_start_date, :string)
    field(:custentity_actgrp_133_last_mod_date, :string)
    field(:custentity_actgrp_133_end_date, :string)
    field(:custentity_actgrp_133_duration, :string)
    field(:custentity_actgrp_133_comments, :string)
    field(:custentity_actgrp_133_comment_history, :string)
    field(:custentity_actgrp_119_status, :string)
    field(:custentity_actgrp_119_start_date, :string)
    field(:custentity_actgrp_119_last_mod_date, :string)
    field(:custentity_actgrp_119_end_date, :string)
    field(:custentity_actgrp_119_duration, :string)
    field(:custentity_actgrp_119_comments, :string)
    field(:custentity_actgrp_119_comment_history, :string)
    field(:custentity_actgrp_11_status, :string)
    field(:custentity_actgrp_11_start_date, :string)
    field(:custentity_actgrp_11_last_mod_date, :string)
    field(:custentity_actgrp_11_end_date, :string)
    field(:custentity_actgrp_11_duration, :string)
    field(:custentity_actgrp_11_comments, :string)
    field(:custentity_actgrp_11_comment_history, :string)
    field(:custentity_skl_on_hold_comment, :string)
    field(:custentity_skl_hs_net_revenue, :string)
    field(:custentity_skl_hs_dealer_fee, :string)
    field(:custentity_bb_warehouse_location, :string)
    field(:custentity_skl_auto_created_nma_document, :string)
    field(:custentity_skl_inverter_size, :string)
    field(:custentity_skl_sales_adders, :string)
    field(:custentity_skl_sales_promises, :string)

    timestamps()
  end

  def new(args) do
    %__MODULE__{
      netsuite_project_id: args["id"],
      estimatedlaborcost: args["estimatedlaborcost"],
      parent: args["parent"],
      timeremaining: args["timeremaining"],
      entityid: args["entityid"],
      estimatedgrossprofit: args["estimatedgrossprofit"],
      actualtime: args["actualtime"],
      allowexpenses: args["allowexpenses"],
      isinactive: args["isinactive"],
      timeapproval: args["timeapproval"],
      entitytitle: args["entitytitle"],
      datecreated: args["datecreated"],
      cseg_bb_project: args["cseg_bb_project"],
      links: args["links"],
      estimatedtime: args["estimatedtime"],
      startdate: args["startdate"],
      altname: args["altname"],
      customer: args["customer"],
      percenttimecomplete: args["percenttimecomplete"],
      allowallresourcesfortasks: args["allowallresourcesfortasks"],
      includecrmtasksintotals: args["includecrmtasksintotals"],
      entitynumber: args["entitynumber"],
      isexempttime: args["isexempttime"],
      estimatedtimeoverride: args["estimatedtimeoverride"],
      limittimetoassignees: args["limittimetoassignees"],
      materializetime: args["materializetime"],
      estimatedlaborrevenue: args["estimatedlaborrevenue"],
      allowtime: args["allowtime"],
      lastmodifieddate: args["lastmodifieddate"],
      isutilizedtime: args["isutilizedtime"],
      isproductivetime: args["isproductivetime"],
      custentitysk_update_hubspot_deal: args["custentitysk_update_hubspot_deal"],
      custentitybb_change_of_scope_comments: args["custentitybb_change_of_scope_comments"],
      custentity2: args["custentity2"],
      custentity_bb_on_hold_reason: args["custentity_bb_on_hold_reason"],
      custentity_ss_customer_class: args["custentity_ss_customer_class"],
      custentity_skyline_bludoc_create: args["custentity_skyline_bludoc_create"],
      custentity_skl_hubspot_id: args["custentity_skl_hubspot_id"],
      custentity_skl_hs_updatedidtodeal: args["custentity_skl_hs_updatedidtodeal"],
      custentity_skl_hs_dealid: args["custentity_skl_hs_dealid"],
      custentity_skl_currentmilestone: args["custentity_skl_currentmilestone"],
      custentity_sk_xcel_premise_number: args["custentity_sk_xcel_premise_number"],
      custentity_sk_utility_account_number: args["custentity_sk_utility_account_number"],
      custentity_sk_utility_account_name: args["custentity_sk_utility_account_name"],
      custentity_sk_upsized_inverter: args["custentity_sk_upsized_inverter"],
      custentity_sk_trenching_length: args["custentity_sk_trenching_length"],
      custentity_sk_trenching_ground_type: args["custentity_sk_trenching_ground_type"],
      custentity_sk_tree_trimming: args["custentity_sk_tree_trimming"],
      custentity_sk_smart_thermostat: args["custentity_sk_smart_thermostat"],
      custentity_sk_site_survey_date: args["custentity_sk_site_survey_date"],
      custentity_sk_second_inverter_model: args["custentity_sk_second_inverter_model"],
      custentity_sk_sales_rep: args["custentity_sk_sales_rep"],
      custentity_sk_roof_repairs: args["custentity_sk_roof_repairs"],
      custentity_sk_roof_reinforcement: args["custentity_sk_roof_reinforcement"],
      custentity_sk_roof_pitch: args["custentity_sk_roof_pitch"],
      custentity_sk_referred_by: args["custentity_sk_referred_by"],
      custentity_sk_proposal_link: args["custentity_sk_proposal_link"],
      custentity_sk_primary_language: args["custentity_sk_primary_language"],
      custentity_sk_premium_panels: args["custentity_sk_premium_panels"],
      custentity_sk_permit_number: args["custentity_sk_permit_number"],
      custentity_sk_panel_skirts: args["custentity_sk_panel_skirts"],
      custentity_sk_number_of_arrays: args["custentity_sk_number_of_arrays"],
      custentity_sk_nps_score: args["custentity_sk_nps_score"],
      custentity_sk_nma_number: args["custentity_sk_nma_number"],
      custentity_sk_module_size: args["custentity_sk_module_size"],
      custentity_sk_module_model: args["custentity_sk_module_model"],
      custentity_sk_meter_upgrade: args["custentity_sk_meter_upgrade"],
      custentity_sk_meter_combine: args["custentity_sk_meter_combine"],
      custentity_sk_main_panel_upgrade: args["custentity_sk_main_panel_upgrade"],
      custentity_sk_led: args["custentity_sk_led"],
      custentity_sk_inverter_model: args["custentity_sk_inverter_model"],
      custentity_sk_interest_rate: args["custentity_sk_interest_rate"],
      custentity_sk_hoi_received: args["custentity_sk_hoi_received"],
      custentity_sk_finance_term_length: args["custentity_sk_finance_term_length"],
      custentity_sk_extended_product: args["custentity_sk_extended_product"],
      custentity_sk_extended_invertery_warrant: args["custentity_sk_extended_invertery_warrant"],
      custentity_sk_ev_charger: args["custentity_sk_ev_charger"],
      custentity_sk_derate_breaker: args["custentity_sk_derate_breaker"],
      custentity_sk_critter_guard: args["custentity_sk_critter_guard"],
      custentity_sk_closing_customer_notes: args["custentity_sk_closing_customer_notes"],
      custentity_sk_cash_back: args["custentity_sk_cash_back"],
      custentity_sk_battery_model: args["custentity_sk_battery_model"],
      custentity_sk_array_type: args["custentity_sk_array_type"],
      custentity_inv_enrg_consmptn_src_lst: args["custentity_inv_enrg_consmptn_src_lst"],
      custentity_bludocs_gdrive_viewer: args["custentity_bludocs_gdrive_viewer"],
      custentity_bbss_configuration: args["custentity_bbss_configuration"],
      custentity_bb_zoning_text: args["custentity_bb_zoning_text"],
      custentity_bb_wrnty_pay_comments_text: args["custentity_bb_wrnty_pay_comments_text"],
      custentity_bb_wrnty_expiration_date: args["custentity_bb_wrnty_expiration_date"],
      custentity_bb_warranty_service_amount: args["custentity_bb_warranty_service_amount"],
      custentity_bb_warranty_reserve_amount: args["custentity_bb_warranty_reserve_amount"],
      custentity_bb_warranty_inventory_amount: args["custentity_bb_warranty_inventory_amount"],
      custentity_bb_warranty_comments_text: args["custentity_bb_warranty_comments_text"],
      custentity_bb_utility_zone: args["custentity_bb_utility_zone"],
      custentity_bb_utility_rate_schedule: args["custentity_bb_utility_rate_schedule"],
      custentity_bb_utility_monthly_avg_dec: args["custentity_bb_utility_monthly_avg_dec"],
      custentity_bb_utility_company: args["custentity_bb_utility_company"],
      custentity_bb_uses_proj_actn_tran_schdl: args["custentity_bb_uses_proj_actn_tran_schdl"],
      custentity_bb_tran_comments_text: args["custentity_bb_tran_comments_text"],
      custentity_bb_total_project_ar_amount: args["custentity_bb_total_project_ar_amount"],
      custentity_bb_total_dealer_fee_amount: args["custentity_bb_total_dealer_fee_amount"],
      custentity_bb_total_contract_value_amt: args["custentity_bb_total_contract_value_amt"],
      custentity_bb_tot_contract_value_cpy_amt: args["custentity_bb_tot_contract_value_cpy_amt"],
      custentity_bb_tot_con_value_per_watt_amt: args["custentity_bb_tot_con_value_per_watt_amt"],
      custentity_bb_timezone: args["custentity_bb_timezone"],
      custentity_bb_tilt_degrees_num: args["custentity_bb_tilt_degrees_num"],
      custentity_bb_system_size_decimal: args["custentity_bb_system_size_decimal"],
      custentity_bb_subst_compl_status_txt: args["custentity_bb_subst_compl_status_txt"],
      custentity_bb_subst_compl_pack_start_dt: args["custentity_bb_subst_compl_pack_start_dt"],
      custentity_bb_subst_compl_pack_end_dt: args["custentity_bb_subst_compl_pack_end_dt"],
      custentity_bb_subst_compl_pack_dur_num: args["custentity_bb_subst_compl_pack_dur_num"],
      custentity_bb_subst_compl_pack_comments: args["custentity_bb_subst_compl_pack_comments"],
      custentity_bb_subst_compl_pack_comm_hist: args["custentity_bb_subst_compl_pack_comm_hist"],
      custentity_bb_subst_compl_last_mod_dt: args["custentity_bb_subst_compl_last_mod_dt"],
      custentity_bb_subinstl_vend_credit_total: args["custentity_bb_subinstl_vend_credit_total"],
      custentity_bb_subinstl_vend_bill_total: args["custentity_bb_subinstl_vend_bill_total"],
      custentity_bb_struct_const_mat_type: args["custentity_bb_struct_const_mat_type"],
      custentity_bb_stories_num: args["custentity_bb_stories_num"],
      custentity_bb_started_from_proj_template: args["custentity_bb_started_from_proj_template"],
      custentity_bb_ss_solaredge_site_id: args["custentity_bb_ss_solaredge_site_id"],
      custentity_bb_ss_sales_tax_account: args["custentity_bb_ss_sales_tax_account"],
      custentity_bb_ss_powerfactors_site_id: args["custentity_bb_ss_powerfactors_site_id"],
      custentity_bb_ss_org_already_billed_amt: args["custentity_bb_ss_org_already_billed_amt"],
      custentity_bb_ss_invoice_day: args["custentity_bb_ss_invoice_day"],
      custentity_bb_ss_inst_already_billed_amt: args["custentity_bb_ss_inst_already_billed_amt"],
      custentity_bb_ss_alsoenergy_site_id: args["custentity_bb_ss_alsoenergy_site_id"],
      custentity_bb_ss_already_invoiced_amount: args["custentity_bb_ss_already_invoiced_amount"],
      custentity_bb_ss_all_pa_files: args["custentity_bb_ss_all_pa_files"],
      custentity_bb_ss_accrual_journal: args["custentity_bb_ss_accrual_journal"],
      custentity_bb_sq_foot_num: args["custentity_bb_sq_foot_num"],
      custentity_bb_spouse_name: args["custentity_bb_spouse_name"],
      custentity_bb_solar_portion_contract_amt: args["custentity_bb_solar_portion_contract_amt"],
      custentity_bb_snap_shot_pay_roll_period: args["custentity_bb_snap_shot_pay_roll_period"],
      custentity_bb_site_audit_vendor: args["custentity_bb_site_audit_vendor"],
      custentity_bb_site_audit_scheduled_date: args["custentity_bb_site_audit_scheduled_date"],
      custentity_bb_site_audit_payment_comment: args["custentity_bb_site_audit_payment_comment"],
      custentity_bb_site_audit_pack_status_txt: args["custentity_bb_site_audit_pack_status_txt"],
      custentity_bb_site_audit_pack_start_date: args["custentity_bb_site_audit_pack_start_date"],
      custentity_bb_site_audit_pack_last_date: args["custentity_bb_site_audit_pack_last_date"],
      custentity_bb_site_audit_pack_end_date: args["custentity_bb_site_audit_pack_end_date"],
      custentity_bb_site_audit_pack_dur_num: args["custentity_bb_site_audit_pack_dur_num"],
      custentity_bb_site_audit_pack_comments: args["custentity_bb_site_audit_pack_comments"],
      custentity_bb_site_audit_pack_comm_hist: args["custentity_bb_site_audit_pack_comm_hist"],
      custentity_bb_site_audit_contact_email: args["custentity_bb_site_audit_contact_email"],
      custentity_bb_site_audit_amount: args["custentity_bb_site_audit_amount"],
      custentity_bb_shipping_amount: args["custentity_bb_shipping_amount"],
      custentity_bb_ship_zip_text: args["custentity_bb_ship_zip_text"],
      custentity_bb_ship_state: args["custentity_bb_ship_state"],
      custentity_bb_ship_city_text: args["custentity_bb_ship_city_text"],
      custentity_bb_ship_address_2_text: args["custentity_bb_ship_address_2_text"],
      custentity_bb_ship_address_1_text: args["custentity_bb_ship_address_1_text"],
      custentity_bb_services_costs_pr_watt_amt: args["custentity_bb_services_costs_pr_watt_amt"],
      custentity_bb_services_costs_amount: args["custentity_bb_services_costs_amount"],
      custentity_bb_sep_kwh_integer: args["custentity_bb_sep_kwh_integer"],
      custentity_bb_second_inverter_qty_num: args["custentity_bb_second_inverter_qty_num"],
      custentity_bb_second_inverter_item: args["custentity_bb_second_inverter_item"],
      custentity_bb_second_inverter_desc_text: args["custentity_bb_second_inverter_desc_text"],
      custentity_bb_sales_tax_amount: args["custentity_bb_sales_tax_amount"],
      custentity_bb_sales_rep_employee: args["custentity_bb_sales_rep_employee"],
      custentity_bb_sales_rep_email: args["custentity_bb_sales_rep_email"],
      custentity_bb_sales_rep_comm_amt: args["custentity_bb_sales_rep_comm_amt"],
      custentity_bb_sales_rep_comm_amt_overrid: args["custentity_bb_sales_rep_comm_amt_overrid"],
      custentity_bb_sales_partner_pay_schedule: args["custentity_bb_sales_partner_pay_schedule"],
      custentity_bb_sales_cost_p_watt_amount: args["custentity_bb_sales_cost_p_watt_amount"],
      custentity_bb_sales_cost_amount: args["custentity_bb_sales_cost_amount"],
      custentity_bb_roof_type: args["custentity_bb_roof_type"],
      custentity_bb_roof_structure_type: args["custentity_bb_roof_structure_type"],
      custentity_bb_roof_material_type: args["custentity_bb_roof_material_type"],
      custentity_bb_rma_comments_text: args["custentity_bb_rma_comments_text"],
      custentity_bb_rma_amount: args["custentity_bb_rma_amount"],
      custentity_bb_revenue_per_watt_amount: args["custentity_bb_revenue_per_watt_amount"],
      custentity_bb_revenue_amount: args["custentity_bb_revenue_amount"],
      custentity_bb_requires_hoa_application: args["custentity_bb_requires_hoa_application"],
      custentity_bb_require_call_ahead: args["custentity_bb_require_call_ahead"],
      custentity_bb_requested_delivery_date: args["custentity_bb_requested_delivery_date"],
      custentity_bb_recent_seller_text: args["custentity_bb_recent_seller_text"],
      custentity_bb_recent_buyer_text: args["custentity_bb_recent_buyer_text"],
      custentity_bb_rebate_variance_amount: args["custentity_bb_rebate_variance_amount"],
      custentity_bb_rebate_package_status_text: args["custentity_bb_rebate_package_status_text"],
      custentity_bb_rebate_package_start_date: args["custentity_bb_rebate_package_start_date"],
      custentity_bb_rebate_package_last_mod_dt: args["custentity_bb_rebate_package_last_mod_dt"],
      custentity_bb_rebate_package_end_date: args["custentity_bb_rebate_package_end_date"],
      custentity_bb_rebate_package_comments: args["custentity_bb_rebate_package_comments"],
      custentity_bb_rebate_pack_duration_num: args["custentity_bb_rebate_pack_duration_num"],
      custentity_bb_rebate_pack_comm_history: args["custentity_bb_rebate_pack_comm_history"],
      custentity_bb_rebate_included_yes_no: args["custentity_bb_rebate_included_yes_no"],
      custentity_bb_rebate_customer: args["custentity_bb_rebate_customer"],
      custentity_bb_rebate_confirmation_amount: args["custentity_bb_rebate_confirmation_amount"],
      custentity_bb_rebate_conf_amount_copy: args["custentity_bb_rebate_conf_amount_copy"],
      custentity_bb_rebate_assignee: args["custentity_bb_rebate_assignee"],
      custentity_bb_rebate_assignee_copy_text: args["custentity_bb_rebate_assignee_copy_text"],
      custentity_bb_rebate_application_amount: args["custentity_bb_rebate_application_amount"],
      custentity_bb_rebate_app_amount_copy: args["custentity_bb_rebate_app_amount_copy"],
      custentity_bb_pv_production_meter_url: args["custentity_bb_pv_production_meter_url"],
      custentity_bb_pv_production_meter_item: args["custentity_bb_pv_production_meter_item"],
      custentity_bb_pv_prod_meter_id_text: args["custentity_bb_pv_prod_meter_id_text"],
      custentity_bb_proposal_generated_date: args["custentity_bb_proposal_generated_date"],
      custentity_bb_property_feet_decimal: args["custentity_bb_property_feet_decimal"],
      custentity_bb_prop_type: args["custentity_bb_prop_type"],
      custentity_bb_project_sub_stage_text: args["custentity_bb_project_sub_stage_text"],
      custentity_bb_project_status: args["custentity_bb_project_status"],
      custentity_bb_project_start_date: args["custentity_bb_project_start_date"],
      custentity_bb_project_stage_text: args["custentity_bb_project_stage_text"],
      custentity_bb_project_so: args["custentity_bb_project_so"],
      custentity_bb_project_serial_number_text: args["custentity_bb_project_serial_number_text"],
      custentity_bb_project_program_type: args["custentity_bb_project_program_type"],
      custentity_bb_project_partner: args["custentity_bb_project_partner"],
      custentity_bb_project_manager_employee: args["custentity_bb_project_manager_employee"],
      custentity_bb_project_location: args["custentity_bb_project_location"],
      custentity_bb_project_acctg_method: args["custentity_bb_project_acctg_method"],
      custentity_bb_proj_install_type: args["custentity_bb_proj_install_type"],
      custentity_bb_proj_install_dates_html: args["custentity_bb_proj_install_dates_html"],
      custentity_bb_proj_inspection_dates_html: args["custentity_bb_proj_inspection_dates_html"],
      custentity_bb_proj_inc_stmnt: args["custentity_bb_proj_inc_stmnt"],
      custentity_bb_proj_home_type: args["custentity_bb_proj_home_type"],
      custentity_bb_proj_google_maps_zoom: args["custentity_bb_proj_google_maps_zoom"],
      custentity_bb_proj_fin_accpt_dates_html: args["custentity_bb_proj_fin_accpt_dates_html"],
      custentity_bb_proj_design_dates_html: args["custentity_bb_proj_design_dates_html"],
      custentity_bb_proj_dates_html: args["custentity_bb_proj_dates_html"],
      custentity_bb_proj_cac_dates_html: args["custentity_bb_proj_cac_dates_html"],
      custentity_bb_proj_bal_sheet: args["custentity_bb_proj_bal_sheet"],
      custentity_bb_proj_address_text: args["custentity_bb_proj_address_text"],
      custentity_bb_price_per_kwh_amount: args["custentity_bb_price_per_kwh_amount"],
      custentity_bb_prefers_site_audit_as_addr: args["custentity_bb_prefers_site_audit_as_addr"],
      custentity_bb_prefers_design_amt_as_addr: args["custentity_bb_prefers_design_amt_as_addr"],
      custentity_bb_pay_on_hold_user: args["custentity_bb_pay_on_hold_user"],
      custentity_bb_paid_comm_amount: args["custentity_bb_paid_comm_amount"],
      custentity_bb_owner_verification_text: args["custentity_bb_owner_verification_text"],
      custentity_bb_originator_vendor: args["custentity_bb_originator_vendor"],
      custentity_bb_originator_pymt_memo_html: args["custentity_bb_originator_pymt_memo_html"],
      custentity_bb_originator_per_watt_amt: args["custentity_bb_originator_per_watt_amt"],
      custentity_bb_originator_pay_memo_html: args["custentity_bb_originator_pay_memo_html"],
      custentity_bb_originator_email: args["custentity_bb_originator_email"],
      custentity_bb_originator_base_p_watt_amt: args["custentity_bb_originator_base_p_watt_amt"],
      custentity_bb_originator_base_amt: args["custentity_bb_originator_base_amt"],
      custentity_bb_orig_vend_credit_total: args["custentity_bb_orig_vend_credit_total"],
      custentity_bb_orig_vend_bill_total: args["custentity_bb_orig_vend_bill_total"],
      custentity_bb_orig_tot_vendor_bill_amt: args["custentity_bb_orig_tot_vendor_bill_amt"],
      custentity_bb_orig_payout_total: args["custentity_bb_orig_payout_total"],
      custentity_bb_orig_payments_on_hold_bool: args["custentity_bb_orig_payments_on_hold_bool"],
      custentity_bb_orig_payment_on_hold_date: args["custentity_bb_orig_payment_on_hold_date"],
      custentity_bb_orig_pay_total_overide_amt: args["custentity_bb_orig_pay_total_overide_amt"],
      custentity_bb_orig_override_user: args["custentity_bb_orig_override_user"],
      custentity_bb_orig_override_date: args["custentity_bb_orig_override_date"],
      custentity_bb_orig_override_boolean: args["custentity_bb_orig_override_boolean"],
      custentity_bb_orgntr_per_watt_adder_amt: args["custentity_bb_orgntr_per_watt_adder_amt"],
      custentity_bb_orgntr_per_mod_adder_amt: args["custentity_bb_orgntr_per_mod_adder_amt"],
      custentity_bb_orgntr_per_ft_addr_ttl_amt: args["custentity_bb_orgntr_per_ft_addr_ttl_amt"],
      custentity_bb_orgntr_payment_tot_amt: args["custentity_bb_orgntr_payment_tot_amt"],
      custentity_bb_orgntr_pay_tot_p_w_amt: args["custentity_bb_orgntr_pay_tot_p_w_amt"],
      custentity_bb_orgntr_m7_vbill_perc: args["custentity_bb_orgntr_m7_vbill_perc"],
      custentity_bb_orgntr_m7_vbill_amt: args["custentity_bb_orgntr_m7_vbill_amt"],
      custentity_bb_orgntr_m6_vbill_perc: args["custentity_bb_orgntr_m6_vbill_perc"],
      custentity_bb_orgntr_m6_vbill_amt: args["custentity_bb_orgntr_m6_vbill_amt"],
      custentity_bb_orgntr_m5_vbill_perc: args["custentity_bb_orgntr_m5_vbill_perc"],
      custentity_bb_orgntr_m5_vbill_amt: args["custentity_bb_orgntr_m5_vbill_amt"],
      custentity_bb_orgntr_m4_vbill_perc: args["custentity_bb_orgntr_m4_vbill_perc"],
      custentity_bb_orgntr_m4_vbill_amt: args["custentity_bb_orgntr_m4_vbill_amt"],
      custentity_bb_orgntr_m3_vbill_perc: args["custentity_bb_orgntr_m3_vbill_perc"],
      custentity_bb_orgntr_m3_vbill_amt: args["custentity_bb_orgntr_m3_vbill_amt"],
      custentity_bb_orgntr_m2_vbill_perc: args["custentity_bb_orgntr_m2_vbill_perc"],
      custentity_bb_orgntr_m2_vbill_amt: args["custentity_bb_orgntr_m2_vbill_amt"],
      custentity_bb_orgntr_m1_vbill_perc: args["custentity_bb_orgntr_m1_vbill_perc"],
      custentity_bb_orgntr_m1_vbill_amt: args["custentity_bb_orgntr_m1_vbill_amt"],
      custentity_bb_orgntr_m0_vbill_perc: args["custentity_bb_orgntr_m0_vbill_perc"],
      custentity_bb_orgntr_m0_vbill_amt: args["custentity_bb_orgntr_m0_vbill_amt"],
      custentity_bb_orgntr_fxd_addr_ttl_amt: args["custentity_bb_orgntr_fxd_addr_ttl_amt"],
      custentity_bb_orgntr_addr_ttl_p_watt_amt: args["custentity_bb_orgntr_addr_ttl_p_watt_amt"],
      custentity_bb_orgntr_addr_ttl_amt: args["custentity_bb_orgntr_addr_ttl_amt"],
      custentity_bb_oct_kwh_integer: args["custentity_bb_oct_kwh_integer"],
      custentity_bb_ob_project_uuid: args["custentity_bb_ob_project_uuid"],
      custentity_bb_nov_kwh_integer: args["custentity_bb_nov_kwh_integer"],
      custentity_bb_net_price_per_watt: args["custentity_bb_net_price_per_watt"],
      custentity_bb_mounting_type: args["custentity_bb_mounting_type"],
      custentity_bb_months_in_contract_num: args["custentity_bb_months_in_contract_num"],
      custentity_bb_module_quantity_num: args["custentity_bb_module_quantity_num"],
      custentity_bb_module_item: args["custentity_bb_module_item"],
      custentity_bb_module_install_doc: args["custentity_bb_module_install_doc"],
      custentity_bb_module_description_text: args["custentity_bb_module_description_text"],
      custentity_bb_middle_name: args["custentity_bb_middle_name"],
      custentity_bb_medeek_snow_load: args["custentity_bb_medeek_snow_load"],
      custentity_bb_medeek_716_wind_risk_i: args["custentity_bb_medeek_716_wind_risk_i"],
      custentity_bb_may_kwh_integer: args["custentity_bb_may_kwh_integer"],
      custentity_bb_marketing_campaign: args["custentity_bb_marketing_campaign"],
      custentity_bb_market_value_num: args["custentity_bb_market_value_num"],
      custentity_bb_market_segment: args["custentity_bb_market_segment"],
      custentity_bb_mar_kwh_integer: args["custentity_bb_mar_kwh_integer"],
      custentity_bb_manual_paid_comm_amount: args["custentity_bb_manual_paid_comm_amount"],
      custentity_bb_m7_sub_install_date: args["custentity_bb_m7_sub_install_date"],
      custentity_bb_m7_sub_install_action: args["custentity_bb_m7_sub_install_action"],
      custentity_bb_m7_origination_date: args["custentity_bb_m7_origination_date"],
      custentity_bb_m7_origination_action: args["custentity_bb_m7_origination_action"],
      custentity_bb_m7_finance_action: args["custentity_bb_m7_finance_action"],
      custentity_bb_m7_dealer_fee_amount: args["custentity_bb_m7_dealer_fee_amount"],
      custentity_bb_m7_date: args["custentity_bb_m7_date"],
      custentity_bb_m6_sub_install_date: args["custentity_bb_m6_sub_install_date"],
      custentity_bb_m6_sub_install_action: args["custentity_bb_m6_sub_install_action"],
      custentity_bb_m6_origination_date: args["custentity_bb_m6_origination_date"],
      custentity_bb_m6_origination_action: args["custentity_bb_m6_origination_action"],
      custentity_bb_m6_finance_action: args["custentity_bb_m6_finance_action"],
      custentity_bb_m6_dealer_fee_amount: args["custentity_bb_m6_dealer_fee_amount"],
      custentity_bb_m6_date: args["custentity_bb_m6_date"],
      custentity_bb_m5_sub_install_date: args["custentity_bb_m5_sub_install_date"],
      custentity_bb_m5_sub_install_action: args["custentity_bb_m5_sub_install_action"],
      custentity_bb_m5_origination_date: args["custentity_bb_m5_origination_date"],
      custentity_bb_m5_origination_action: args["custentity_bb_m5_origination_action"],
      custentity_bb_m5_finance_action: args["custentity_bb_m5_finance_action"],
      custentity_bb_m5_dealer_fee_amount: args["custentity_bb_m5_dealer_fee_amount"],
      custentity_bb_m5_date: args["custentity_bb_m5_date"],
      custentity_bb_m4_sub_install_date: args["custentity_bb_m4_sub_install_date"],
      custentity_bb_m4_sub_install_action: args["custentity_bb_m4_sub_install_action"],
      custentity_bb_m4_origination_date: args["custentity_bb_m4_origination_date"],
      custentity_bb_m4_origination_action: args["custentity_bb_m4_origination_action"],
      custentity_bb_m4_finance_action: args["custentity_bb_m4_finance_action"],
      custentity_bb_m4_dealer_fee_amount: args["custentity_bb_m4_dealer_fee_amount"],
      custentity_bb_m4_date: args["custentity_bb_m4_date"],
      custentity_bb_m3_sub_install_date: args["custentity_bb_m3_sub_install_date"],
      custentity_bb_m3_sub_install_action: args["custentity_bb_m3_sub_install_action"],
      custentity_bb_m3_origination_date: args["custentity_bb_m3_origination_date"],
      custentity_bb_m3_origination_action: args["custentity_bb_m3_origination_action"],
      custentity_bb_m3_finance_action: args["custentity_bb_m3_finance_action"],
      custentity_bb_m3_dealer_fee_amount: args["custentity_bb_m3_dealer_fee_amount"],
      custentity_bb_m3_date: args["custentity_bb_m3_date"],
      custentity_bb_m2_sub_install_date: args["custentity_bb_m2_sub_install_date"],
      custentity_bb_m2_sub_install_action: args["custentity_bb_m2_sub_install_action"],
      custentity_bb_m2_origination_date: args["custentity_bb_m2_origination_date"],
      custentity_bb_m2_origination_action: args["custentity_bb_m2_origination_action"],
      custentity_bb_m2_finance_action: args["custentity_bb_m2_finance_action"],
      custentity_bb_m2_dealer_fee_amount: args["custentity_bb_m2_dealer_fee_amount"],
      custentity_bb_m2_date: args["custentity_bb_m2_date"],
      custentity_bb_m1_sub_install_date: args["custentity_bb_m1_sub_install_date"],
      custentity_bb_m1_sub_install_action: args["custentity_bb_m1_sub_install_action"],
      custentity_bb_m1_origination_date: args["custentity_bb_m1_origination_date"],
      custentity_bb_m1_origination_action: args["custentity_bb_m1_origination_action"],
      custentity_bb_m1_finance_action: args["custentity_bb_m1_finance_action"],
      custentity_bb_m1_dealer_fee_amount: args["custentity_bb_m1_dealer_fee_amount"],
      custentity_bb_m1_date: args["custentity_bb_m1_date"],
      custentity_bb_m0_sub_install_date: args["custentity_bb_m0_sub_install_date"],
      custentity_bb_m0_sub_install_action: args["custentity_bb_m0_sub_install_action"],
      custentity_bb_m0_origination_date: args["custentity_bb_m0_origination_date"],
      custentity_bb_m0_origination_action: args["custentity_bb_m0_origination_action"],
      custentity_bb_m0_finance_action: args["custentity_bb_m0_finance_action"],
      custentity_bb_m0_dealer_fee_amount: args["custentity_bb_m0_dealer_fee_amount"],
      custentity_bb_m0_date: args["custentity_bb_m0_date"],
      custentity_bb_lot_size_num: args["custentity_bb_lot_size_num"],
      custentity_bb_loan_id_text: args["custentity_bb_loan_id_text"],
      custentity_bb_lead_vendor: args["custentity_bb_lead_vendor"],
      custentity_bb_lead_start_date: args["custentity_bb_lead_start_date"],
      custentity_bb_last_name: args["custentity_bb_last_name"],
      custentity_bb_jun_kwh_integer: args["custentity_bb_jun_kwh_integer"],
      custentity_bb_jul_kwh_integer: args["custentity_bb_jul_kwh_integer"],
      custentity_bb_jan_kwh_integer: args["custentity_bb_jan_kwh_integer"],
      custentity_bb_is_vendor_owned_inverter: args["custentity_bb_is_vendor_owned_inverter"],
      custentity_bb_is_residential_delivery: args["custentity_bb_is_residential_delivery"],
      custentity_bb_is_project_template: args["custentity_bb_is_project_template"],
      custentity_bb_is_occupied: args["custentity_bb_is_occupied"],
      custentity_bb_inverter_quantity_num: args["custentity_bb_inverter_quantity_num"],
      custentity_bb_inverter_item: args["custentity_bb_inverter_item"],
      custentity_bb_inverter_description_text: args["custentity_bb_inverter_description_text"],
      custentity_bb_inverter_comments_text: args["custentity_bb_inverter_comments_text"],
      custentity_bb_inventory_amount: args["custentity_bb_inventory_amount"],
      custentity_bb_instllr_pr_wt_addr_ttl_amt: args["custentity_bb_instllr_pr_wt_addr_ttl_amt"],
      custentity_bb_instllr_pr_md_addr_ttl_amt: args["custentity_bb_instllr_pr_md_addr_ttl_amt"],
      custentity_bb_installr_p_ft_addr_ttl_amt: args["custentity_bb_installr_p_ft_addr_ttl_amt"],
      custentity_bb_installer_vbill_ttl_amt: args["custentity_bb_installer_vbill_ttl_amt"],
      custentity_bb_installer_total_pay_amt: args["custentity_bb_installer_total_pay_amt"],
      custentity_bb_installer_price_p_w: args["custentity_bb_installer_price_p_w"],
      custentity_bb_installer_pay_memo_html: args["custentity_bb_installer_pay_memo_html"],
      custentity_bb_installer_partner_vendor: args["custentity_bb_installer_partner_vendor"],
      custentity_bb_installer_main_conct_email: args["custentity_bb_installer_main_conct_email"],
      custentity_bb_installer_m7_vbill_perc: args["custentity_bb_installer_m7_vbill_perc"],
      custentity_bb_installer_m7_vbill_amt: args["custentity_bb_installer_m7_vbill_amt"],
      custentity_bb_installer_m6_vbill_perc: args["custentity_bb_installer_m6_vbill_perc"],
      custentity_bb_installer_m6_vbill_amt: args["custentity_bb_installer_m6_vbill_amt"],
      custentity_bb_installer_m5_vbill_perc: args["custentity_bb_installer_m5_vbill_perc"],
      custentity_bb_installer_m5_vbill_amt: args["custentity_bb_installer_m5_vbill_amt"],
      custentity_bb_installer_m4_vbill_perc: args["custentity_bb_installer_m4_vbill_perc"],
      custentity_bb_installer_m4_vbill_amt: args["custentity_bb_installer_m4_vbill_amt"],
      custentity_bb_installer_m3_vbill_perc: args["custentity_bb_installer_m3_vbill_perc"],
      custentity_bb_installer_m3_vbill_amt: args["custentity_bb_installer_m3_vbill_amt"],
      custentity_bb_installer_m2_vbill_perc: args["custentity_bb_installer_m2_vbill_perc"],
      custentity_bb_installer_m2_vbill_amt: args["custentity_bb_installer_m2_vbill_amt"],
      custentity_bb_installer_m1_vbill_perc: args["custentity_bb_installer_m1_vbill_perc"],
      custentity_bb_installer_m1_vbill_amt: args["custentity_bb_installer_m1_vbill_amt"],
      custentity_bb_installer_m0_vbill_perc: args["custentity_bb_installer_m0_vbill_perc"],
      custentity_bb_installer_m0_vbill_amt: args["custentity_bb_installer_m0_vbill_amt"],
      custentity_bb_installer_fxd_addr_ttl_amt: args["custentity_bb_installer_fxd_addr_ttl_amt"],
      custentity_bb_installer_amt: args["custentity_bb_installer_amt"],
      custentity_bb_installer_adder_total_amt: args["custentity_bb_installer_adder_total_amt"],
      custentity_bb_install_zip_code_text: args["custentity_bb_install_zip_code_text"],
      custentity_bb_install_total_payment_p_w: args["custentity_bb_install_total_payment_p_w"],
      custentity_bb_install_state: args["custentity_bb_install_state"],
      custentity_bb_install_scheduled_date: args["custentity_bb_install_scheduled_date"],
      custentity_bb_install_payout_total: args["custentity_bb_install_payout_total"],
      custentity_bb_install_pay_total_ovrd_amt: args["custentity_bb_install_pay_total_ovrd_amt"],
      custentity_bb_install_part_pay_schedule: args["custentity_bb_install_part_pay_schedule"],
      custentity_bb_install_comp_pack_stat_txt: args["custentity_bb_install_comp_pack_stat_txt"],
      custentity_bb_install_comp_pack_start_dt: args["custentity_bb_install_comp_pack_start_dt"],
      custentity_bb_install_comp_pack_last_dt: args["custentity_bb_install_comp_pack_last_dt"],
      custentity_bb_install_comp_pack_end_date: args["custentity_bb_install_comp_pack_end_date"],
      custentity_bb_install_comp_pack_dur_num: args["custentity_bb_install_comp_pack_dur_num"],
      custentity_bb_install_comp_pack_date: args["custentity_bb_install_comp_pack_date"],
      custentity_bb_install_comp_pack_comments: args["custentity_bb_install_comp_pack_comments"],
      custentity_bb_install_comp_pack_comm_his: args["custentity_bb_install_comp_pack_comm_his"],
      custentity_bb_install_comp_deadline_date: args["custentity_bb_install_comp_deadline_date"],
      custentity_bb_install_city_text: args["custentity_bb_install_city_text"],
      custentity_bb_install_address_2_text: args["custentity_bb_install_address_2_text"],
      custentity_bb_install_address_1_text: args["custentity_bb_install_address_1_text"],
      custentity_bb_install_adder_tot_p_w_amt: args["custentity_bb_install_adder_tot_p_w_amt"],
      custentity_bb_inspection_partner_vendor: args["custentity_bb_inspection_partner_vendor"],
      custentity_bb_inspection_main_cont_email: args["custentity_bb_inspection_main_cont_email"],
      custentity_bb_inspection_amount: args["custentity_bb_inspection_amount"],
      custentity_bb_inspect_pay_comments_text: args["custentity_bb_inspect_pay_comments_text"],
      custentity_bb_homeowner_finance_method: args["custentity_bb_homeowner_finance_method"],
      custentity_bb_homeowner_customer: args["custentity_bb_homeowner_customer"],
      custentity_bb_homeowner_association: args["custentity_bb_homeowner_association"],
      custentity_bb_home_owner_primary_email: args["custentity_bb_home_owner_primary_email"],
      custentity_bb_home_owner_phone: args["custentity_bb_home_owner_phone"],
      custentity_bb_home_owner_name_text: args["custentity_bb_home_owner_name_text"],
      custentity_bb_home_owner_alt_email: args["custentity_bb_home_owner_alt_email"],
      custentity_bb_hoa_zip_text: args["custentity_bb_hoa_zip_text"],
      custentity_bb_hoa_turn_around: args["custentity_bb_hoa_turn_around"],
      custentity_bb_hoa_review_time_text: args["custentity_bb_hoa_review_time_text"],
      custentity_bb_hoa_phone: args["custentity_bb_hoa_phone"],
      custentity_bb_hoa_package_status_text: args["custentity_bb_hoa_package_status_text"],
      custentity_bb_hoa_package_start_date: args["custentity_bb_hoa_package_start_date"],
      custentity_bb_hoa_package_last_mod_date: args["custentity_bb_hoa_package_last_mod_date"],
      custentity_bb_hoa_package_end_date: args["custentity_bb_hoa_package_end_date"],
      custentity_bb_hoa_package_comments: args["custentity_bb_hoa_package_comments"],
      custentity_bb_hoa_package_comm_history: args["custentity_bb_hoa_package_comm_history"],
      custentity_bb_hoa_pack_duration_num: args["custentity_bb_hoa_pack_duration_num"],
      custentity_bb_hoa_name_text: args["custentity_bb_hoa_name_text"],
      custentity_bb_hoa_email: args["custentity_bb_hoa_email"],
      custentity_bb_hoa_deposit_status_text: args["custentity_bb_hoa_deposit_status_text"],
      custentity_bb_ho_credit_approval_date: args["custentity_bb_ho_credit_approval_date"],
      custentity_bb_ho_contacted_site_audit_dt: args["custentity_bb_ho_contacted_site_audit_dt"],
      custentity_bb_has_lift_gate: args["custentity_bb_has_lift_gate"],
      custentity_bb_gross_trading_profit_amt: args["custentity_bb_gross_trading_profit_amt"],
      custentity_bb_gross_profit_percent: args["custentity_bb_gross_profit_percent"],
      custentity_bb_gross_profit_amount: args["custentity_bb_gross_profit_amount"],
      custentity_bb_gross_adder_total: args["custentity_bb_gross_adder_total"],
      custentity_bb_google_maps_api_key: args["custentity_bb_google_maps_api_key"],
      custentity_bb_gen_rebate_on_milestone: args["custentity_bb_gen_rebate_on_milestone"],
      custentity_bb_foundation_type: args["custentity_bb_foundation_type"],
      custentity_bb_forecasted_install_date: args["custentity_bb_forecasted_install_date"],
      custentity_bb_forecasted_close_date: args["custentity_bb_forecasted_close_date"],
      custentity_bb_forecast_type: args["custentity_bb_forecast_type"],
      custentity_bb_forecast_site_survey_date: args["custentity_bb_forecast_site_survey_date"],
      custentity_bb_forecast_pto_date: args["custentity_bb_forecast_pto_date"],
      custentity_bb_forecast_permit_date: args["custentity_bb_forecast_permit_date"],
      custentity_bb_forecast_inspection_date: args["custentity_bb_forecast_inspection_date"],
      custentity_bb_forecast_design_date: args["custentity_bb_forecast_design_date"],
      custentity_bb_first_name: args["custentity_bb_first_name"],
      custentity_bb_fincancer_email: args["custentity_bb_fincancer_email"],
      custentity_bb_financing_type: args["custentity_bb_financing_type"],
      custentity_bb_financier_stips_comment: args["custentity_bb_financier_stips_comment"],
      custentity_bb_financier_payment_schedule: args["custentity_bb_financier_payment_schedule"],
      custentity_bb_financier_loan_url: args["custentity_bb_financier_loan_url"],
      custentity_bb_financier_customer: args["custentity_bb_financier_customer"],
      custentity_bb_financier_adv_pmt_schedule: args["custentity_bb_financier_adv_pmt_schedule"],
      custentity_bb_final_completion_date: args["custentity_bb_final_completion_date"],
      custentity_bb_final_acc_pack_status_text: args["custentity_bb_final_acc_pack_status_text"],
      custentity_bb_final_acc_pack_start_date: args["custentity_bb_final_acc_pack_start_date"],
      custentity_bb_final_acc_pack_last_mod_dt: args["custentity_bb_final_acc_pack_last_mod_dt"],
      custentity_bb_final_acc_pack_end_date: args["custentity_bb_final_acc_pack_end_date"],
      custentity_bb_final_acc_pack_comments: args["custentity_bb_final_acc_pack_comments"],
      custentity_bb_final_acc_pack_com_history: args["custentity_bb_final_acc_pack_com_history"],
      custentity_bb_fin_total_invoice_amount: args["custentity_bb_fin_total_invoice_amount"],
      custentity_bb_fin_total_fees_amount: args["custentity_bb_fin_total_fees_amount"],
      custentity_bb_fin_rebate_inv_amount: args["custentity_bb_fin_rebate_inv_amount"],
      custentity_bb_fin_pur_price_p_watt_amt: args["custentity_bb_fin_pur_price_p_watt_amt"],
      custentity_bb_fin_proposal_id_text: args["custentity_bb_fin_proposal_id_text"],
      custentity_bb_fin_prelim_purch_price_amt: args["custentity_bb_fin_prelim_purch_price_amt"],
      custentity_bb_fin_per_watt_adder_amt: args["custentity_bb_fin_per_watt_adder_amt"],
      custentity_bb_fin_per_module_adder_amt: args["custentity_bb_fin_per_module_adder_amt"],
      custentity_bb_fin_per_foot_adder_amt: args["custentity_bb_fin_per_foot_adder_amt"],
      custentity_bb_fin_payment_memo_html: args["custentity_bb_fin_payment_memo_html"],
      custentity_bb_fin_owned_equip_costs_amt: args["custentity_bb_fin_owned_equip_costs_amt"],
      custentity_bb_fin_orig_per_watt_amt: args["custentity_bb_fin_orig_per_watt_amt"],
      custentity_bb_fin_orig_base_per_watt_amt: args["custentity_bb_fin_orig_base_per_watt_amt"],
      custentity_bb_fin_orig_base_amt: args["custentity_bb_fin_orig_base_amt"],
      custentity_bb_fin_monitoring_fee_amount: args["custentity_bb_fin_monitoring_fee_amount"],
      custentity_bb_fin_m7_invoice_percent: args["custentity_bb_fin_m7_invoice_percent"],
      custentity_bb_fin_m7_invoice_amount: args["custentity_bb_fin_m7_invoice_amount"],
      custentity_bb_fin_m6_invoice_percent: args["custentity_bb_fin_m6_invoice_percent"],
      custentity_bb_fin_m6_invoice_amount: args["custentity_bb_fin_m6_invoice_amount"],
      custentity_bb_fin_m5_invoice_percent: args["custentity_bb_fin_m5_invoice_percent"],
      custentity_bb_fin_m5_invoice_amount: args["custentity_bb_fin_m5_invoice_amount"],
      custentity_bb_fin_m4_invoice_percent: args["custentity_bb_fin_m4_invoice_percent"],
      custentity_bb_fin_m4_invoice_amount: args["custentity_bb_fin_m4_invoice_amount"],
      custentity_bb_fin_m3_invoice_percent: args["custentity_bb_fin_m3_invoice_percent"],
      custentity_bb_fin_m3_invoice_amount: args["custentity_bb_fin_m3_invoice_amount"],
      custentity_bb_fin_m2_invoice_percent: args["custentity_bb_fin_m2_invoice_percent"],
      custentity_bb_fin_m2_invoice_amount: args["custentity_bb_fin_m2_invoice_amount"],
      custentity_bb_fin_m1_invoice_percent: args["custentity_bb_fin_m1_invoice_percent"],
      custentity_bb_fin_m1_invoice_amount: args["custentity_bb_fin_m1_invoice_amount"],
      custentity_bb_fin_m0_invoice_percent: args["custentity_bb_fin_m0_invoice_percent"],
      custentity_bb_fin_m0_invoice_amount: args["custentity_bb_fin_m0_invoice_amount"],
      custentity_bb_fin_install_per_watt_amt: args["custentity_bb_fin_install_per_watt_amt"],
      custentity_bb_fin_install_base_amt: args["custentity_bb_fin_install_base_amt"],
      custentity_bb_fin_fixed_adder_amt: args["custentity_bb_fin_fixed_adder_amt"],
      custentity_bb_fin_customer_id_text: args["custentity_bb_fin_customer_id_text"],
      custentity_bb_fin_base_fees_amount: args["custentity_bb_fin_base_fees_amount"],
      custentity_bb_feb_kwh_integer: args["custentity_bb_feb_kwh_integer"],
      custentity_bb_fa_pack_duration_num: args["custentity_bb_fa_pack_duration_num"],
      custentity_bb_estimated_annual_kwh_dec: args["custentity_bb_estimated_annual_kwh_dec"],
      custentity_bb_est_annual_savings_amt: args["custentity_bb_est_annual_savings_amt"],
      custentity_bb_equipment_disposition: args["custentity_bb_equipment_disposition"],
      custentity_bb_equip_tran_comments_text: args["custentity_bb_equip_tran_comments_text"],
      custentity_bb_equip_shipping_apprvl_date: args["custentity_bb_equip_shipping_apprvl_date"],
      custentity_bb_equip_shipping_approval: args["custentity_bb_equip_shipping_approval"],
      custentity_bb_equip_ship_contact_txt: args["custentity_bb_equip_ship_contact_txt"],
      custentity_bb_equip_cost_per_watt_amount: args["custentity_bb_equip_cost_per_watt_amount"],
      custentity_bb_equip_cost_amount: args["custentity_bb_equip_cost_amount"],
      custentity_bb_epc_role: args["custentity_bb_epc_role"],
      custentity_bb_entity_property_link: args["custentity_bb_entity_property_link"],
      custentity_bb_entity_property_image: args["custentity_bb_entity_property_image"],
      custentity_bb_entity_longitude_text: args["custentity_bb_entity_longitude_text"],
      custentity_bb_entity_latitude_text: args["custentity_bb_entity_latitude_text"],
      custentity_bb_energy_rate_type: args["custentity_bb_energy_rate_type"],
      custentity_bb_energy_rate_schedule: args["custentity_bb_energy_rate_schedule"],
      custentity_bb_energy_production_source: args["custentity_bb_energy_production_source"],
      custentity_bb_down_payment_all_milestone: args["custentity_bb_down_payment_all_milestone"],
      custentity_bb_difference_approver: args["custentity_bb_difference_approver"],
      custentity_bb_difference_approved_date: args["custentity_bb_difference_approved_date"],
      custentity_bb_design_payment_comments: args["custentity_bb_design_payment_comments"],
      custentity_bb_design_partner_vendor: args["custentity_bb_design_partner_vendor"],
      custentity_bb_design_package_start_date: args["custentity_bb_design_package_start_date"],
      custentity_bb_design_package_end_date: args["custentity_bb_design_package_end_date"],
      custentity_bb_design_package_comments: args["custentity_bb_design_package_comments"],
      custentity_bb_design_pack_status_text: args["custentity_bb_design_pack_status_text"],
      custentity_bb_design_pack_last_mod_date: args["custentity_bb_design_pack_last_mod_date"],
      custentity_bb_design_pack_duration_num: args["custentity_bb_design_pack_duration_num"],
      custentity_bb_design_pack_comm_history: args["custentity_bb_design_pack_comm_history"],
      custentity_bb_design_main_contact_email: args["custentity_bb_design_main_contact_email"],
      custentity_bb_design_amount: args["custentity_bb_design_amount"],
      custentity_bb_dedct_rebate_all_milestone: args["custentity_bb_dedct_rebate_all_milestone"],
      custentity_bb_dec_kwh_integer: args["custentity_bb_dec_kwh_integer"],
      custentity_bb_dealer_fee_percent: args["custentity_bb_dealer_fee_percent"],
      custentity_bb_dealer_fee_app_method: args["custentity_bb_dealer_fee_app_method"],
      custentity_bb_datatree_hoa_name_text: args["custentity_bb_datatree_hoa_name_text"],
      custentity_bb_customer_signture_date: args["custentity_bb_customer_signture_date"],
      custentity_bb_customer_category: args["custentity_bb_customer_category"],
      custentity_bb_cust_record_link: args["custentity_bb_cust_record_link"],
      custentity_bb_credit_initiated_date: args["custentity_bb_credit_initiated_date"],
      custentity_bb_copy_to: args["custentity_bb_copy_to"],
      custentity_bb_copy_from: args["custentity_bb_copy_from"],
      custentity_bb_contract_value_hist_html: args["custentity_bb_contract_value_hist_html"],
      custentity_bb_contract_pack_status_text: args["custentity_bb_contract_pack_status_text"],
      custentity_bb_contract_pack_start_date: args["custentity_bb_contract_pack_start_date"],
      custentity_bb_contract_pack_last_mod_dt: args["custentity_bb_contract_pack_last_mod_dt"],
      custentity_bb_contract_pack_end_date: args["custentity_bb_contract_pack_end_date"],
      custentity_bb_contract_pack_dur_num: args["custentity_bb_contract_pack_dur_num"],
      custentity_bb_contract_pack_comments: args["custentity_bb_contract_pack_comments"],
      custentity_bb_contract_pack_comm_history: args["custentity_bb_contract_pack_comm_history"],
      custentity_bb_comm_snap_shot_record: args["custentity_bb_comm_snap_shot_record"],
      custentity_bb_comm_history_notes: args["custentity_bb_comm_history_notes"],
      custentity_bb_comm_difference_approved: args["custentity_bb_comm_difference_approved"],
      custentity_bb_change_of_scope_reason: args["custentity_bb_change_of_scope_reason"],
      custentity_bb_change_of_scope_date: args["custentity_bb_change_of_scope_date"],
      custentity_bb_cancellation_reason: args["custentity_bb_cancellation_reason"],
      custentity_bb_cancellation_reason_comm: args["custentity_bb_cancellation_reason_comm"],
      custentity_bb_cancellation_date: args["custentity_bb_cancellation_date"],
      custentity_bb_call_ahead_phone: args["custentity_bb_call_ahead_phone"],
      custentity_bb_cac_resigned_date: args["custentity_bb_cac_resigned_date"],
      custentity_bb_cac_deadline_date: args["custentity_bb_cac_deadline_date"],
      custentity_bb_built_year_num: args["custentity_bb_built_year_num"],
      custentity_bb_bom_status_list: args["custentity_bb_bom_status_list"],
      custentity_bb_bom_printed_date: args["custentity_bb_bom_printed_date"],
      custentity_bb_bom_edited: args["custentity_bb_bom_edited"],
      custentity_bb_bodhi_project_id_text: args["custentity_bb_bodhi_project_id_text"],
      custentity_bb_battery: args["custentity_bb_battery"],
      custentity_bb_battery_quantity: args["custentity_bb_battery_quantity"],
      custentity_bb_azimuth_degrees_num: args["custentity_bb_azimuth_degrees_num"],
      custentity_bb_avg_utilitybill_month_amt: args["custentity_bb_avg_utilitybill_month_amt"],
      custentity_bb_auth_having_jurisdiction: args["custentity_bb_auth_having_jurisdiction"],
      custentity_bb_aug_kwh_integer: args["custentity_bb_aug_kwh_integer"],
      custentity_bb_assessor_parcel_num: args["custentity_bb_assessor_parcel_num"],
      custentity_bb_apr_kwh_integer: args["custentity_bb_apr_kwh_integer"],
      custentity_bb_alt_phone: args["custentity_bb_alt_phone"],
      custentity_bb_adv_payment_schdl_tot_amt: args["custentity_bb_adv_payment_schdl_tot_amt"],
      custentity_bb_adv_payment_schdl_percent: args["custentity_bb_adv_payment_schdl_percent"],
      custentity_bb_adv_payment_schdl_count: args["custentity_bb_adv_payment_schdl_count"],
      custentity_bb_actual_equipment_ship_date: args["custentity_bb_actual_equipment_ship_date"],
      custentity_bb_act_wrnty_total_amount: args["custentity_bb_act_wrnty_total_amount"],
      custentity_bb_accrual_je_created_date: args["custentity_bb_accrual_je_created_date"],
      custentity_actgrp_8_status: args["custentity_actgrp_8_status"],
      custentity_actgrp_8_start_date: args["custentity_actgrp_8_start_date"],
      custentity_actgrp_8_last_mod_date: args["custentity_actgrp_8_last_mod_date"],
      custentity_actgrp_8_end_date: args["custentity_actgrp_8_end_date"],
      custentity_actgrp_8_duration: args["custentity_actgrp_8_duration"],
      custentity_actgrp_8_comments: args["custentity_actgrp_8_comments"],
      custentity_actgrp_8_comment_history: args["custentity_actgrp_8_comment_history"],
      custentity_actgrp_5_status: args["custentity_actgrp_5_status"],
      custentity_actgrp_5_start_date: args["custentity_actgrp_5_start_date"],
      custentity_actgrp_5_last_mod_date: args["custentity_actgrp_5_last_mod_date"],
      custentity_actgrp_5_end_date: args["custentity_actgrp_5_end_date"],
      custentity_actgrp_5_duration: args["custentity_actgrp_5_duration"],
      custentity_actgrp_5_comments: args["custentity_actgrp_5_comments"],
      custentity_actgrp_5_comment_history: args["custentity_actgrp_5_comment_history"],
      custentity_actgrp_136_status: args["custentity_actgrp_136_status"],
      custentity_actgrp_136_start_date: args["custentity_actgrp_136_start_date"],
      custentity_actgrp_136_last_mod_date: args["custentity_actgrp_136_last_mod_date"],
      custentity_actgrp_136_end_date: args["custentity_actgrp_136_end_date"],
      custentity_actgrp_136_duration: args["custentity_actgrp_136_duration"],
      custentity_actgrp_136_comments: args["custentity_actgrp_136_comments"],
      custentity_actgrp_136_comment_history: args["custentity_actgrp_136_comment_history"],
      custentity_actgrp_133_status: args["custentity_actgrp_133_status"],
      custentity_actgrp_133_start_date: args["custentity_actgrp_133_start_date"],
      custentity_actgrp_133_last_mod_date: args["custentity_actgrp_133_last_mod_date"],
      custentity_actgrp_133_end_date: args["custentity_actgrp_133_end_date"],
      custentity_actgrp_133_duration: args["custentity_actgrp_133_duration"],
      custentity_actgrp_133_comments: args["custentity_actgrp_133_comments"],
      custentity_actgrp_133_comment_history: args["custentity_actgrp_133_comment_history"],
      custentity_actgrp_119_status: args["custentity_actgrp_119_status"],
      custentity_actgrp_119_start_date: args["custentity_actgrp_119_start_date"],
      custentity_actgrp_119_last_mod_date: args["custentity_actgrp_119_last_mod_date"],
      custentity_actgrp_119_end_date: args["custentity_actgrp_119_end_date"],
      custentity_actgrp_119_duration: args["custentity_actgrp_119_duration"],
      custentity_actgrp_119_comments: args["custentity_actgrp_119_comments"],
      custentity_actgrp_119_comment_history: args["custentity_actgrp_119_comment_history"],
      custentity_actgrp_11_status: args["custentity_actgrp_11_status"],
      custentity_actgrp_11_start_date: args["custentity_actgrp_11_start_date"],
      custentity_actgrp_11_last_mod_date: args["custentity_actgrp_11_last_mod_date"],
      custentity_actgrp_11_end_date: args["custentity_actgrp_11_end_date"],
      custentity_actgrp_11_duration: args["custentity_actgrp_11_duration"],
      custentity_actgrp_11_comments: args["custentity_actgrp_11_comments"],
      custentity_actgrp_11_comment_history: args["custentity_actgrp_11_comment_history"],
      custentity_skl_on_hold_comment: args["custentity_skl_on_hold_comment"],
      custentity_skl_hs_net_revenue: args["custentity_skl_hs_net_revenue"],
      custentity_skl_hs_dealer_fee: args["custentity_skl_hs_dealer_fee"],
      custentity_bb_warehouse_location: args["custentity_bb_warehouse_location"],
      custentity_skl_auto_created_nma_document: args["custentity_skl_auto_created_nma_document"],
      custentity_skl_inverter_size: args["custentity_skl_inverter_size"],
      custentity_skl_sales_adders: args["custentity_skl_sales_adders"],
      custentity_skl_sales_promises: args["custentity_skl_sales_promises"]
    }
  end

  def changeset(original, attrs \\ %{}) do
    original
    |> cast(attrs, @fields)
    |> unique_constraint([:netsuite_project_id])
  end

  def create(%Ecto.Changeset{valid?: true} = attrs) do
    attrs
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_project_id)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_project_id)
  end

  def read() do
    Repo.all(__MODULE__)
  end

  def read(query) do
    Repo.all(query)
  end

  def update(original, attrs) do
    original
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete(original) do
    original
    |> Repo.delete!()
  end
end
