defmodule SkylineEmployeeManager.Seed do
  def seed() do
    seed_employees_google()
    add_equipment_to_list()
  end

  def add_equipment_to_list() do
    [
      {"yofran.pirela@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"jason.richard@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"derick.tinsley@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 7500,
           type: "Adapter",
           store_link: "https://www.amazon.com/USB-Dual-HDMI-Adapter-External/dp/B0725K1MHH"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!()
       ]},
      {"terri.sibbet@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 7500,
           type: "Adapter",
           store_link: "https://www.amazon.com/USB-Dual-HDMI-Adapter-External/dp/B0725K1MHH"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 7500,
           type: "Docking Station",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"amanda.hilton@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 7500,
           type: "Adapter",
           store_link: "https://www.amazon.com/USB-Dual-HDMI-Adapter-External/dp/B0725K1MHH"
         }
         |> Repo.insert!()
       ]},
      {"whitney.peterson@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Desktop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 7500,
           type: "Adapter",
           store_link: "https://www.amazon.com/USB-Dual-HDMI-Adapter-External/dp/B0725K1MHH"
         }
         |> Repo.insert!()
       ]},
      {"charles.west@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"kortnie.garcia@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Desktop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Webcam",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"lauren.vaughan@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!()
       ]},
      {"tina.bhakta@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Desktop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!()
       ]},
      {"eric.clarke@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"liam.bloomer@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"tristan.boling@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"jgarcia@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"michelle.lhotak@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 7500,
           type: "Adapter",
           store_link: "https://www.amazon.com/USB-Dual-HDMI-Adapter-External/dp/B0725K1MHH"
         }
         |> Repo.insert!()
       ]},
      {"kelsey.moss@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!()
       ]},
      {"joe.tedesco@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!()
       ]},
      {"michael.le@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 7500,
           type: "Adapter",
           store_link: "https://www.amazon.com/USB-Dual-HDMI-Adapter-External/dp/B0725K1MHH"
         }
         |> Repo.insert!()
       ]},
      {"billy.thuma@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"tasia@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"scott.sowby@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"kristal@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"neal.butler@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Desktop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"brenda.jarrett@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"kyle@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Desktop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"desiree.bailey@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!()
       ]},
      {"shanell.skeem@org",
       [
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 70000,
           type: "Laptop",
           store_link: ""
         }
         |> Repo.insert!(),
         %SkylineEmployeeManager.SkylineItEquipment{
           cost: 15000,
           type: "Monitor",
           store_link: "https://www.amazon.com/HP-Pavilion-21-5-Inch-Monitor-22cwa/dp/B015WCV70W"
         }
         |> Repo.insert!()
       ]}
    ]
    |> Enum.map(fn {email, equipment} -> add_equipment_to(email, equipment) end)
  end

  def add_equipment_to(email, equipment) do
    employee = Repo.get_by!(SkylineEmployeeManager.SkylineEmployee, email: email)

    {:ok, _employee} = SkylineEmployeeManager.add_equipment_to_employee(employee, equipment)
  end

  def seed_employees_google() do
    SkylineGoogle.Users.Collector.get_users()
    |> Enum.filter(fn g_user -> g_user.name.fullName in known_check_out_employees() end)
    |> Enum.map(fn g_user ->
      %SkylineEmployeeManager.SkylineEmployee{
        first_name: g_user.name.givenName,
        last_name: g_user.name.familyName,
        email: g_user.primaryEmail,
        department: g_user.orgUnitPath
      }
      |> Repo.insert!()
    end)
  end

  def known_check_out_employees() do
    [
      "Amanda Hilton",
      "Billy Thuma",
      "Brenda Jarrett",
      "Charles West",
      "Derick Tinsley",
      "Desiree Bailey",
      "Eric Clarke",
      "Jason Richard",
      "Jessica Hinds",
      "Joe Tedesco",
      "Josue Garcia",
      "Kelsey Moss",
      "Kortnie Garcia",
      "Kristal Curnett",
      "Kyle Larsen",
      "Lauren Vaughan",
      "Liam Bloomer",
      "Michael Le",
      "Michelle Lhotak",
      "Neal Butler",
      "Scott Sowby",
      "Shanell Skeem",
      "Tasia Andersen",
      "Terri Sibbet",
      "Tina Bhakta",
      "Tristan Boling",
      "Whitney Peterson",
      "Yofran Pirela"
    ]
  end
end
