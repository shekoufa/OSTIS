package com.howtodoinjava.service;

import java.util.List;

import com.howtodoinjava.entity.Employee;
import com.howtodoinjava.entity.Translation;

public interface EmployeeManager {
	//This method will be called when a employee object is added
    public void addEmployee(Employee employee);
    //This method return list of employees in database
    public List<Employee> getAllEmployees();
    //Deletes a employee by it's id
    public void deleteEmployee(Integer employeeId);
    public List<Translation> findTranslationByWordEn(String enWord);
    public List<Translation> findTranslationByWordFa(String faWord);
    public List<Translation> findPendingTranslationsByWordFa();
    public List<Translation> findPendingTranslationsByWordEn();
    public List<Translation> findTranslationByWordEnStatusless(String enWord);
    public List<Translation> findTranslationByWordFaStatusless(String faWord);
    public void addRequest(String reqWord);

    public Translation findTranslationById(Integer wordId);

    public void remove(Object theObject);
    public void updateTranslation(Translation translation);

}
