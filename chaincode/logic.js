'use strict';
const { Contract } = require('fabric-contract-api');

class studentContract extends Contract {

  async queryStudent(ctx, studentId) {

    const studentAsBytes = await ctx.stub.getState(studentId);
    if (!studentAsBytes || studentAsBytes.toString().length <= 0) {
      throw new Error(`Student with this Id '${studentId}' does not exist.!`);
    }
    return JSON.parse(studentAsBytes);
  }

  async addStudent(ctx, studentId, name, age, sex, grade) {
    const studentObj = {
      name,
      age,
      sex,
      grade
    }
    console.log('Adding student to the ledger.');
    await ctx.stub.putState(studentId, Buffer.from(JSON.stringify(studentObj)));
  }

  async updateStudent(ctx, studentId, name, age, sex, grade) {
    const studentAsBytes = await ctx.stub.getState(studentId);
    if (!studentAsBytes || studentAsBytes.toString().length <= 0) {
      throw new Error(`Student with this Id '${studentId}' does not exist.!`);
    }
    const student = JSON.parse(studentAsBytes);
    student.name = name;
    student.age = age;
    student.sex = sex;
    student.grade = grade;
    console.log('Updating student.');
    await ctx.stub.putState(studentId, Buffer.from(JSON.stringify(student)));
  }

  async deleteStudent(ctx, studentId) {
    console.log('deleting student from the ledger.');
    await ctx.stub.deleteState(studentId);
  }
}

module.exports = studentContract;
