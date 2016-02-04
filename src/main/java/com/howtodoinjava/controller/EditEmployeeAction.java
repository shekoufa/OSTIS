package com.howtodoinjava.controller;

import java.util.List;
import java.util.logging.Logger;


import com.howtodoinjava.entity.Employee;
import com.howtodoinjava.entity.Translation;
import com.howtodoinjava.service.EmployeeManager;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.Preparable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

public class EditEmployeeAction extends ActionSupport implements Preparable	
{
	private static final long serialVersionUID = 1L;
	
	//Logger configured using log4j
	private static final Logger logger = Logger.getLogger(String.valueOf(EditEmployeeAction.class));
	//List of employees; Setter and Getter are below
	private List<Employee> employees;
	//Employee object to be added; Setter and Getter are below
	private Employee employee;
    private String requestMessage;
	
	//Employee manager injected by spring context; This is cool !!
    @Autowired
	private EmployeeManager employeeManager;
    private String enWord;
    private String faWord;
    private List<Translation> translations;
    private Translation translation;
    private String reqWord;
    private List<Translation> pendingTranslations;

    //This method return list of employees in database
	public String listEmployees() {
		logger.info("listEmployees method called");
		return SUCCESS;
	}
    public String search(){
        logger.info("search method called");
        translations = employeeManager.findTranslationByWordFa(translation.getFaWord());
        return SUCCESS;
    }
    public String addRequest(){
        logger.info("addRequest method called");
        List<Translation> result = employeeManager.findTranslationByWordFaStatusless(reqWord);
        if(result.size()==0){
            employeeManager.addRequest(reqWord);
            requestMessage = "Your request was stored in our database. It will be processed soon!";
        }else{
            requestMessage = "This request has been already stored in our database. Try searching the word again later!";
        }
        return SUCCESS;
    }
    public Integer wordId;

    public Integer getWordId() {
        return wordId;
    }

    public void setWordId(Integer wordId) {
        this.wordId = wordId;
    }

    public String rejectWord(){
        Translation theTranslation = employeeManager.findTranslationById(wordId);
        if(theTranslation!=null){
            employeeManager.remove(theTranslation);
        }
        return SUCCESS;
    }
    public String translateWord(){
        Translation theTranslation = employeeManager.findTranslationById(wordId);
        theTranslation.setEnWord(translation.getEnWord());
        theTranslation.setStatus("approved");
        employeeManager.updateTranslation(theTranslation);
        return SUCCESS;
    }
    public String showPendings(){
        logger.info("showPendings method called");
        pendingTranslations = employeeManager.findPendingTranslationsByWordFa();
        return SUCCESS;
    }

	//This method will be called when a employee object is added
	public String addEmployee() {
		logger.info("addEmployee method called");
		employeeManager.addEmployee(employee);
		return SUCCESS;
	}

	//Deletes a employee by it's id passed in path parameter
	public String deleteEmployee() {
		logger.info("deleteEmployee method called");
		employeeManager.deleteEmployee(employee.getId());
		return SUCCESS;
	}
	
	//This method will be called before any of Action method is invoked;
	//So some pre-processing if required.
	@Override
	public void prepare() throws Exception {
		employee = null;
	}

	public void setEmployeeManager(EmployeeManager employeeManager) {
		this.employeeManager = employeeManager;
	}

	public List<Employee> getEmployees() {
		return employees;
	}

	public void setEmployees(List<Employee> employees) {
		this.employees = employees;
	}

	public Employee getEmployee() {
		return employee;
	}

	public void setEmployee(Employee employee) {
		this.employee = employee;
	}

    public List<Translation> getTranslations() {
        return translations;
    }

    public void setTranslations(List<Translation> translations) {
        this.translations = translations;
    }

    public Translation getTranslation() {
        return translation;
    }

    public void setTranslation(Translation translation) {
        this.translation = translation;
    }

    public String getReqWord() {
        return reqWord;
    }

    public void setReqWord(String reqWord) {
        this.reqWord = reqWord;
    }

    public String getRequestMessage() {
        return requestMessage;
    }

    public void setRequestMessage(String requestMessage) {
        this.requestMessage = requestMessage;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public static Logger getLogger() {
        return logger;
    }

    public EmployeeManager getEmployeeManager() {
        return employeeManager;
    }

    public String getEnWord() {
        return enWord;
    }

    public void setEnWord(String enWord) {
        this.enWord = enWord;
    }

    public String getFaWord() {
        return faWord;
    }

    public void setFaWord(String faWord) {
        this.faWord = faWord;
    }

    public List<Translation> getPendingTranslations() {
        return pendingTranslations;
    }

    public void setPendingTranslations(List<Translation> pendingTranslations) {
        this.pendingTranslations = pendingTranslations;
    }
}
