/** This script maps all claim lines to an encounter type.
    Institutional claims will be mapped using the revenue code and/or bill type code.
    Profession claims will be mapped using the place of service codes.
    A SQL case statement evaluates condition sequentially and will stop when the first condition is satisfied.
        That means that revenue codes 0303 and 0304 will always map to dialysis regardless of any bill type code condition it may meet
        further down the line  
    A visual representation of this crosswalk is available in Miro:  https://miro.com/app/board/uXjVOzD3Lyg=/?share_link_id=38987910984**/

with encounter_crosswalk as(
  select
      case
          when revenue_center_code in ('0303','0304') 
              then 'dialysis'
          when revenue_center_code in ('0450','0459') 
              then 'emergency department'
          when revenue_center_code in ('0270','0271','0272','0274','0275','0276','0278','0279') 
              then 'dme'
          when revenue_center_code in ('0540', '0545') 
              then 'ambulance'
          when revenue_center_code in ('0360', '0361', '0490', '0499') 
              then 'ambulatory surgical center'
          when left(bill_type_code,2) in ('11', '12', '41', '42', '48') 
              then 'acute inpatient'
          when left(bill_type_code,2) = '13' and revenue_center_code in ('0300','0301','0302','0305','0306','0307','0309','0310','0311','0312','0314','0319')
          /** Laboratory, Chemistry, Immunology, Hematology, Bacteriology & microbiology, Urology, ther laboratory, Laboratory - pathological, Cytology, Histology, Biopsy, Other **/
              then 'lab'
          when left(bill_type_code,2) = '13' and revenue_center_code in ('0350','0351','0352','0359'
                                                                          /** CT scan, Head scan, Body Scan, Other **/
            ,'0400','0401','0402','0403','0404','0409'
            /** Image service, Diagnostic mammography, Ultrasound, Screen mammography, Positron emission tomography, Other imaging services **/
            ,'0610','0611','0612','0619')
            /** MRI, Brain (including brain stem), Spinal cord (including spine), Other MRI **/
              then 'imaging'
          when left(bill_type_code,2) = '13' 
              then 'outpatient'
          when left(bill_type_code,2) = '14' 
              then 'lab'
          when left(bill_type_code,2) in ('15', '16', '17', '18', '19', '21', '22', '24', '25', '26', '27', '28', '45', '46', '47') 
              then 'skilled nursing facility'
          when left(bill_type_code,2) = '23' and revenue_center_code in ('0300','0301','0302','0305','0306','0307','0309','0310','0311','0312','0314','0319')
          /** Laboratory, Chemistry, Immunology, Hematology, Bacteriology & microbiology, Urology, ther laboratory, Laboratory - pathological, Cytology, Histology, Biopsy, Other **/
              then 'lab'
          when left(bill_type_code,2) = '23' and revenue_center_code in ('0350','0351','0352','0359'
                                                                          /** CT scan, Head scan, Body Scan, Other **/
            ,'0400','0401','0402','0403','0404','0409'
            /** Image service, Diagnostic mammography, Ultrasound, Screen mammography, Positron emission tomography, Other imaging services **/
            ,'0610','0611','0612','0619')
            /** MRI, Brain (including brain stem), Spinal cord (including spine), Other MRI **/
              then 'imaging'
          when left(bill_type_code,2) = '23' 
              then 'outpatient'
          when left(bill_type_code,2) in ('31', '32', '34', '35', '36', '37', '38') 
              then 'home health'
          when left(bill_type_code,2) = '33' and revenue_center_code in ('0300','0301','0302','0305','0306','0307','0309','0310','0311','0312','0314','0319')
          /** Laboratory, Chemistry, Immunology, Hematology, Bacteriology & microbiology, Urology, ther laboratory, Laboratory - pathological, Cytology, Histology, Biopsy, Other **/
              then 'lab'
          when left(bill_type_code,2) = '33' and revenue_center_code in ('0350','0351','0352','0359'
                                                                          /** CT scan, Head scan, Body Scan, Other **/
            ,'0400','0401','0402','0403','0404','0409'
            /** Image service, Diagnostic mammography, Ultrasound, Screen mammography, Positron emission tomography, Other imaging services **/
            ,'0610','0611','0612','0619')
            /** MRI, Brain (including brain stem), Spinal cord (including spine), Other MRI **/
              then 'imaging'
          when left(bill_type_code,2) = '33' 
              then 'outpatient'
          when left(bill_type_code,2) = '43' and revenue_center_code in ('0300','0301','0302','0305','0306','0307','0309','0310','0311','0312','0314','0319')
          /** Laboratory, Chemistry, Immunology, Hematology, Bacteriology & microbiology, Urology, ther laboratory, Laboratory - pathological, Cytology, Histology, Biopsy, Other **/
              then 'lab'
          when left(bill_type_code,2) = '43' and revenue_center_code in ('0350','0351','0352','0359'
                                                                          /** CT scan, Head scan, Body Scan, Other **/
            ,'0400','0401','0402','0403','0404','0409'
            /** Image service, Diagnostic mammography, Ultrasound, Screen mammography, Positron emission tomography, Other imaging services **/
            ,'0610','0611','0612','0619')
            /** MRI, Brain (including brain stem), Spinal cord (including spine), Other MRI **/
              then 'imaging'
          when left(bill_type_code,2) = '43' 
              then 'outpatient'
          when left(bill_type_code,2) in ('51', '52', '54', '55', '56', '57', '58') 
              then 'assisted living facility'
          when left(bill_type_code,2) = '53' and revenue_center_code in ('0300','0301','0302','0305','0306','0307','0309','0310','0311','0312','0314','0319')
          /** Laboratory, Chemistry, Immunology, Hematology, Bacteriology & microbiology, Urology, ther laboratory, Laboratory - pathological, Cytology, Histology, Biopsy, Other **/
              then 'lab'
          when left(bill_type_code,2) = '53' and revenue_center_code in ('0350','0351','0352','0359'
                                                                          /** CT scan, Head scan, Body Scan, Other **/
            ,'0400','0401','0402','0403','0404','0409'
            /** Image service, Diagnostic mammography, Ultrasound, Screen mammography, Positron emission tomography, Other imaging services **/
            ,'0610','0611','0612','0619')
            /** MRI, Brain (including brain stem), Spinal cord (including spine), Other MRI **/
              then 'imaging'
          when left(bill_type_code,2) = '53' 
              then 'outpatient'
          when left(bill_type_code,2) in ('61', '62', '64', '65', '66', '67', '68') 
              then 'itermediate care facility'
          when left(bill_type_code,2) = '63' and revenue_center_code in ('0300','0301','0302','0305','0306','0307','0309','0310','0311','0312','0314','0319')
          /** Laboratory, Chemistry, Immunology, Hematology, Bacteriology & microbiology, Urology, ther laboratory, Laboratory - pathological, Cytology, Histology, Biopsy, Other **/
              then 'lab'
          when left(bill_type_code,2) = '63' and revenue_center_code in ('0350','0351','0352','0359'
                                                                          /** CT scan, Head scan, Body Scan, Other **/
            ,'0400','0401','0402','0403','0404','0409'
            /** Image service, Diagnostic mammography, Ultrasound, Screen mammography, Positron emission tomography, Other imaging services **/
            ,'0610','0611','0612','0619')
            /** MRI, Brain (including brain stem), Spinal cord (including spine), Other MRI **/
              then 'imaging'
          when left(bill_type_code,2) = '63' 
              then 'outpatient'
          when left(bill_type_code,2) = '71' and revenue_center_code in ('0300','0301','0302','0305','0306','0307','0309','0310','0311','0312','0314','0319')
          /** Laboratory, Chemistry, Immunology, Hematology, Bacteriology & microbiology, Urology, ther laboratory, Laboratory - pathological, Cytology, Histology, Biopsy, Other **/
              then 'lab'
          when left(bill_type_code,2) = '71' and revenue_center_code in ('0350','0351','0352','0359'
                                                                          /** CT scan, Head scan, Body Scan, Other **/
            ,'0400','0401','0402','0403','0404','0409'
            /** Image service, Diagnostic mammography, Ultrasound, Screen mammography, Positron emission tomography, Other imaging services **/
            ,'0610','0611','0612','0619')
            /** MRI, Brain (including brain stem), Spinal cord (including spine), Other MRI **/
              then 'imaging'
          when left(bill_type_code,2) = '71' 
              then 'outpatient'
          when left(bill_type_code,2) = '72'
              then 'dialysis'
          when left(bill_type_code,2) = '73' 
              then 'outpatient'
          when left(bill_type_code,2) = '74' 
              then 'outpatient'
          when left(bill_type_code,2) = '75' 
              then 'outpatient'
          when left(bill_type_code,2) = '76' 
              then 'mental health center'
          when left(bill_type_code,2) = '77' and revenue_center_code in ('0300','0301','0302','0305','0306','0307','0309','0310','0311','0312','0314','0319')
          /** Laboratory, Chemistry, Immunology, Hematology, Bacteriology & microbiology, Urology, ther laboratory, Laboratory - pathological, Cytology, Histology, Biopsy, Other **/
              then 'lab'
          when left(bill_type_code,2) = '77' and revenue_center_code in ('0350','0351','0352','0359'
                                                                          /** CT scan, Head scan, Body Scan, Other **/
            ,'0400','0401','0402','0403','0404','0409'
            /** Image service, Diagnostic mammography, Ultrasound, Screen mammography, Positron emission tomography, Other imaging services **/
            ,'0610','0611','0612','0619')
            /** MRI, Brain (including brain stem), Spinal cord (including spine), Other MRI **/
              then 'imaging'
          when left(bill_type_code,2) = '77' 
              then 'outpatient'
          when left(bill_type_code,2) = '79' 
              then 'other'
          when left(bill_type_code,2) = '81' 
              then 'hospice'
          when left(bill_type_code,2) = '82' 
              then 'hospice'
          when left(bill_type_code,2) = '83' 
              then 'ambulatory surgical center'
          when left(bill_type_code,2) = '84' 
              then 'acute inpatient'
          when left(bill_type_code,2) = '85' 
              then 'outpatient'
          when left(bill_type_code,2) = '89' 
              then 'other'
          when place_of_service_code = '01' then 'other' 
          when place_of_service_code = '02' then 'telehealth' 
          when place_of_service_code = '03' then 'other' 
          when place_of_service_code = '04' then 'other' 
          when place_of_service_code = '05' then 'office visit' 
          when place_of_service_code = '06' then 'office visit' 
          when place_of_service_code = '07' then 'office visit' 
          when place_of_service_code = '08' then 'office visit' 
          when place_of_service_code = '09' then 'office visit' 
          when place_of_service_code = '10' then 'telehealth' 
          when place_of_service_code = '11' then 'office visit' 
          when place_of_service_code = '12' then 'home health' 
          when place_of_service_code = '13' then 'assisted living facility' 
          when place_of_service_code = '14' then 'assisted living facility' 
          when place_of_service_code = '15' then 'other' 
          when place_of_service_code = '16' then 'other' 
          when place_of_service_code = '17' then 'office visit' 
          when place_of_service_code = '18' then 'other' 
          when place_of_service_code = '19' then 'outpatient' 
          when place_of_service_code = '20' then 'office visit' 
          when place_of_service_code = '21' then 'acute inpatient' 
          when place_of_service_code = '22' then 'outpatient' 
          when place_of_service_code = '23' then 'emergency department' 
          when place_of_service_code = '24' then 'ambulatory surgical center' 
          when place_of_service_code = '25' then 'acute inapatient' 
          when place_of_service_code = '26' then 'office visit' 
          when place_of_service_code = '31' then 'skilled nursing facility' 
          when place_of_service_code = '32' then 'skilled nursing facility' 
          when place_of_service_code = '33' then 'assisted living facility' 
          when place_of_service_code = '34' then 'hospice' 
          when place_of_service_code = '41' then 'ambulance' 
          when place_of_service_code = '42' then 'ambulance' 
          when place_of_service_code = '49' then 'office visit' 
          when place_of_service_code = '50' then 'office visit' 
          when place_of_service_code = '51' then 'inpatient psychiatric' 
          when place_of_service_code = '52' then 'inpatient psychiatric' 
          when place_of_service_code = '53' then 'mental health center' 
          when place_of_service_code = '54' then 'intermediate care facility' 
          when place_of_service_code = '55' then 'substance abuse treatment center' 
          when place_of_service_code = '56' then 'inpatient psychiatric' 
          when place_of_service_code = '57' then 'substance abuse treatment center' 
          when place_of_service_code = '58' then 'substance abuse treatment center' 
          when place_of_service_code = '60' then 'other' 
          when place_of_service_code = '61' then 'inpatient rehab' 
          when place_of_service_code = '62' then 'outpatient' 
          when place_of_service_code = '65' then 'dialysis' 
          when place_of_service_code = '71' then 'office visit' 
          when place_of_service_code = '72' then 'office visit' 
          when place_of_service_code = '81' then 'lab' 
          when place_of_service_code = '99' then 'other' 
      end as encounter_type
  ,bill_type_code
  ,revenue_center_code
  ,place_of_service_code
  ,claim_type
  ,claim_id
  ,patient_id
  ,claim_line_number
  ,claim_start_date
  ,claim_end_Date
  ,discharge_disposition_code
  ,facility_npi
from {{ var('medical_claim')}}
where ISNULL(revenue_center_code,'') <> '0001'
/** Revenue center code 0001 = total of all revenue centers.  Omitting since these do not need to be mapped **/
and claim_type in ('I','P')
) 
  
  select
    claim_type
  	,md5(claim_id || encounter_type) as merge_claim_id
    ,claim_id as original_claim_id
    ,claim_line_number
    ,patient_id
    ,encounter_type
    ,claim_start_date
    ,claim_end_date
    ,discharge_disposition_code
    ,facility_npi
    ,bill_type_code
    ,revenue_center_code
    ,place_of_service_code
  from encounter_crosswalk

union all

  select
    claim_type
  	,md5(claim_id || 'DME') as merge_claim_id
    ,claim_id as original_claim_id
    ,claim_line_number
    ,patient_id
    ,'DME' as encounter_type
    ,claim_start_date
    ,claim_end_date
    ,discharge_disposition_code
    ,facility_npi
    ,bill_type_code
    ,revenue_center_code
    ,place_of_service_code
from {{ var('medical_claim')}}
where claim_type = 'DME'