package com.howtodoinjava.service;

import java.util.List;

import com.howtodoinjava.entity.Translation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.howtodoinjava.dao.EmployeeDAO;
import com.howtodoinjava.entity.Employee;

@Service(value = "employeeManager")
public class EmployeeManagerImpl implements EmployeeManager {
    //Employee dao injected by Spring context
    @Autowired
    private EmployeeDAO employeeDAO;

    //This method will be called when a employee object is added
    @Override
    @Transactional
    public void addEmployee(Employee employee) {
        employeeDAO.addEmployee(employee);
    }

    //This method return list of employees in database
    @Override
    @Transactional
    public List<Employee> getAllEmployees() {
        return employeeDAO.getAllEmployees();
    }

    //Deletes a employee by it's id
    @Override
    @Transactional
    public void deleteEmployee(Integer employeeId) {
        employeeDAO.deleteEmployee(employeeId);
    }

    @Override
    @Transactional
    public List<Translation> findTranslationByWordEn(String enWord) {
        return employeeDAO.findTranslationByWordEn(enWord);
    }

    @Override
    @Transactional
    public List<Translation> findTranslationByWordFa(String faWord) {
        return employeeDAO.findTranslationByWordFa(faWord);
    }

    @Override
    @Transactional
    public List<Translation> findPendingTranslationsByWordFa() {
        return employeeDAO.findPendingTranslationsByWordFa();
    }

    @Override
    @Transactional
    public List<Translation> findPendingTranslationsByWordEn() {
        return employeeDAO.findPendingTranslationsByWordEn();
    }

    @Override
    @Transactional
    public List<Translation> findTranslationByWordEnStatusless(String enWord) {
        return employeeDAO.findTranslationByWordEnStatusless(enWord);
    }

    @Override
    @Transactional
    public List<Translation> findTranslationByWordFaStatusless(String faWord) {
        return employeeDAO.findTranslationByWordFaStatusless(faWord);
    }

    @Override
    @Transactional
    public void addRequest(String reqWord) {
        employeeDAO.addRequest(reqWord);
    }

    @Override
    @Transactional
    public Translation findTranslationById(Integer wordId) {
        return employeeDAO.findTranslationById(wordId);
    }

    @Override
    @Transactional
    public void remove(Object theObject) {
        employeeDAO.remove(theObject);
    }

    @Override
    @Transactional
    public void updateTranslation(Translation translation) {
        employeeDAO.updateTranslation(translation);
    }

    //This setter will be used by Spring context to inject the dao's instance
    public void setEmployeeDAO(EmployeeDAO employeeDAO) {
        this.employeeDAO = employeeDAO;
    }
}
