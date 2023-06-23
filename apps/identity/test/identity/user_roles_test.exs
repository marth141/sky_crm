defmodule Identity.UserRolesTest do
  use Identity.DataCase

  alias Identity.UserRoles

  describe "user_roles" do
    alias Identity.UserRoles.Role

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserRoles.create_role()

      role
    end

    test "list_user_roles/0 returns all user_roles" do
      role = role_fixture()
      assert UserRoles.list_user_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert UserRoles.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = UserRoles.create_role(@valid_attrs)
      assert role.title == "some title"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserRoles.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = UserRoles.update_role(role, @update_attrs)
      assert role.title == "some updated title"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = UserRoles.update_role(role, @invalid_attrs)
      assert role == UserRoles.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = UserRoles.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> UserRoles.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = UserRoles.change_role(role)
    end
  end
end
