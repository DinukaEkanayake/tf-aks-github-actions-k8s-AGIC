import React, { useEffect, useState } from "react";
import axios from "axios";
import { Button, Card, Input, Table } from "@/components/ui";
import { PlusCircle, Trash, Edit } from "lucide-react";

const App = () => {
  const [employees, setEmployees] = useState([]);
  const [form, setForm] = useState({ firstName: "", lastName: "", email: "" });
  const [editingId, setEditingId] = useState(null);

  useEffect(() => {
    fetchEmployees();
  }, []);

  const fetchEmployees = async () => {
    try {
      const response = await axios.get("http://localhost:8080/api/employees");
      setEmployees(response.data);
    } catch (error) {
      console.error("Error fetching employees", error);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editingId) {
        await axios.put(`http://localhost:8080/api/employees/${editingId}`, form);
      } else {
        await axios.post("http://localhost:8080/api/employees", form);
      }
      setForm({ firstName: "", lastName: "", email: "" });
      setEditingId(null);
      fetchEmployees();
    } catch (error) {
      console.error("Error saving employee", error);
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`http://localhost:8080/api/employees/${id}`);
      fetchEmployees();
    } catch (error) {
      console.error("Error deleting employee", error);
    }
  };

  const handleEdit = (employee) => {
    setForm(employee);
    setEditingId(employee.id);
  };

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">Employee Management</h1>
      <Card>
        <form onSubmit={handleSubmit} className="space-y-4 p-4">
          <Input
            type="text"
            placeholder="First Name"
            value={form.firstName}
            onChange={(e) => setForm({ ...form, firstName: e.target.value })}
          />
          <Input
            type="text"
            placeholder="Last Name"
            value={form.lastName}
            onChange={(e) => setForm({ ...form, lastName: e.target.value })}
          />
          <Input
            type="email"
            placeholder="Email"
            value={form.email}
            onChange={(e) => setForm({ ...form, email: e.target.value })}
          />
          <Button type="submit" className="w-full">
            {editingId ? "Update Employee" : "Add Employee"}
          </Button>
        </form>
      </Card>
      <Table className="mt-6">
        <thead>
          <tr>
            <th>ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {employees.map((employee) => (
            <tr key={employee.id}>
              <td>{employee.id}</td>
              <td>{employee.firstName}</td>
              <td>{employee.lastName}</td>
              <td>{employee.email}</td>
              <td>
                <Button onClick={() => handleEdit(employee)} className="mr-2">
                  <Edit size={16} />
                </Button>
                <Button onClick={() => handleDelete(employee.id)} variant="destructive">
                  <Trash size={16} />
                </Button>
              </td>
            </tr>
          ))}
        </tbody>
      </Table>
    </div>
  );
};

export default App;

