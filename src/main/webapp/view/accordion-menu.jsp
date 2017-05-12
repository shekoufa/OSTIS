<div id="accordian">
    <ul>
        <li class="active">
            <h3><a href="#"><img src="../images/disease.png" width="20px"/>Disease Type</a></h3>
            <ul>
                <li><a class="disease-selector functional"
                       style="text-decoration: none;"
                       href="javascript:void(0);" onclick="handleActivation(this);"
                       disease="diabetes"><img src="../images/unchecked.png" width="16px"/> Diabetes</a></li>
                <li><a class="disease-selector functional"
                       style="text-decoration: none;"
                       href="javascript:void(0);" onclick="handleActivation(this);"
                       disease="cancer"><img src="../images/unchecked.png" width="16px"/> Obstructive
                    Pulmonary Disease</a></li>
                <li><a class="disease-selector functional"
                       style="text-decoration: none;"
                       href="javascript:void(0);" onclick="handleActivation(this);"
                       disease="hypertension"><img src="../images/unchecked.png" width="16px"/>
                    Hypertension</a></li>
                <li><a class="disease-selector functional"
                       style="text-decoration: none;"
                       href="javascript:void(0);" onclick="handleActivation(this);"
                       disease="mentalillness"><img src="../images/unchecked.png" width="16px"/>
                    Mental Illness</a></li>
                <li><a class="disease-selector functional"
                       style="text-decoration: none;"
                       href="javascript:void(0);" onclick="handleActivation(this);"
                       disease="anxiety"><img src="../images/unchecked.png" width="16px"/> Mood and
                    Anxiety Disorders</a></li>
                <li><a class="disease-selector functional"
                       style="text-decoration: none;"
                       href="javascript:void(0);" onclick="handleActivation(this);"
                       disease="asthma"><img src="../images/unchecked.png" width="16px"/> Asthma</a></li>
                <li><a class="disease-selector functional"
                       style="text-decoration: none;"
                       href="javascript:void(0);" onclick="handleActivation(this);"
                       disease="ischemic-heartdisease"><img
                        src="../images/unchecked.png" width="16px"/> Ischemic Heart Disease</a></li>
                <li><a class="disease-selector functional"
                       style="text-decoration: none;"
                       href="javascript:void(0);" onclick="handleActivation(this);"
                       disease="myocardial"><img src="../images/unchecked.png" width="16px"/> Acute
                    Myocardial Infarction</a></li>
                <li><a class="disease-selector functional"
                       style="text-decoration: none;"
                       href="javascript:void(0);" onclick="handleActivation(this);"
                       disease="heart-failure"><img src="../images/unchecked.png" width="16px"/>
                    Heart Failure</a></li>
            </ul>
        </li>
        <li>
            <h3><a href="#"><img src="../images/year.png" width="20px"/> Year</a></h3>
            <ul>
                <li class="input-class"><br/><input type="text" placeholder="From Year..."
                                                    id="minYear"
                                                    class="form-control input-sm"/><br/></li>
                <li class="input-class"><input type="text" placeholder="To Year..."
                                               id="maxYear"
                                               class="form-control input-sm"/><br/></li>
            </ul>
        </li>
        <li>
            <h3><a href="#"><img src="../images/age.png" width="20px"/> Age</a></h3>
            <ul>
                <li class="input-class"><br/><input type="text" placeholder="From Age..."
                                                    id="minAge"
                                                    class="form-control input-sm"/><br/></li>
                <li class="input-class"><input type="text" placeholder="To Age..."
                                               id="maxAge"
                                               class="form-control input-sm"/><br/></li>
            </ul>
        </li>

        <li>
            <h3><a href="#"><img src="../images/sex.png" width="20px"/>Sex</a></h3>
            <ul>
                <br/>
                <select id="sex" class="form-control input-sm">
                    <option value="*">All</option>
                    <option value="F">Female</option>
                    <option value="M">Male</option>
                </select>
                <br/>
            </ul>
        </li>
        <li>
            <h3><a href="#"><img src="../images/healthcare-utilization.png" width="20px"/>Healthcare Utilization</a></h3>
            <%--TODO: remove this when Healthcare Utilization is implemented completely!--%>
            <input type="hidden" value="*" id="healthcare"/>
            <ul>
                <li>
                    <a href="#">Outpatient</a>
                    <ul>
                        <li>
                            <a href="#">Visit with Family Physician</a>
                            <ul>
                                <li>
                                    <span>Number of Visits:</span>
                                </li>
                                <li class="input-class"><input type="text" placeholder="From number..."

                                                               class="form-control input-sm"/><br/></li>
                                <li class="input-class"><input type="text" placeholder="To number..."

                                                               class="form-control input-sm"/><br/></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#">Visit with Specialist</a>
                            <ul>
                                <li>
                                    <a href="#">Internist</a>
                                    <ul>
                                        <li>
                                            <a href="#">General Internal Medicine</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Endocrinologist</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Cardiologist</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Nephrologist</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Neurologist</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Gastroenterologist</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Rheumatologist</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Respirologist</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Others</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Surgeon</a>
                                    <ul>
                                        <li>
                                            <a href="#">General Surgeon</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Cardiac Surgeon</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Pediatric Surgeon</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Orthopaedic Surgeon</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Neurosurgeon</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li>
                                            <a href="#">Vascular Surgeon</a>
                                            <ul>
                                                <li>
                                                    <span>Number of Visits:</span>
                                                </li>
                                                <li class="input-class"><input type="text" placeholder="From number..."

                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To number..."

                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Dermatologist</a>
                                    <ul>
                                        <li>
                                            <span>Number of Visits:</span>
                                        </li>
                                        <li class="input-class"><input type="text" placeholder="From number..."

                                                                       class="form-control input-sm"/><br/></li>
                                        <li class="input-class"><input type="text" placeholder="To number..."

                                                                       class="form-control input-sm"/><br/></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Psychiatrist</a>
                                    <ul>
                                        <li>
                                            <span>Number of Visits:</span>
                                        </li>
                                        <li class="input-class"><input type="text" placeholder="From number..."

                                                                       class="form-control input-sm"/><br/></li>
                                        <li class="input-class"><input type="text" placeholder="To number..."

                                                                       class="form-control input-sm"/><br/></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Ophthalmologist</a>
                                    <ul>
                                        <li>
                                            <span>Number of Visits:</span>
                                        </li>
                                        <li class="input-class"><input type="text" placeholder="From number..."

                                                                       class="form-control input-sm"/><br/></li>
                                        <li class="input-class"><input type="text" placeholder="To number..."

                                                                       class="form-control input-sm"/><br/></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Obstetrician/Gynecologist</a>
                                    <ul>
                                        <li>
                                            <span>Number of Visits:</span>
                                        </li>
                                        <li class="input-class"><input type="text" placeholder="From number..."

                                                                       class="form-control input-sm"/><br/></li>
                                        <li class="input-class"><input type="text" placeholder="To number..."

                                                                       class="form-control input-sm"/><br/></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Urologist</a>
                                    <ul>
                                        <li>
                                            <span>Number of Visits:</span>
                                        </li>
                                        <li class="input-class"><input type="text" placeholder="From number..."

                                                                       class="form-control input-sm"/><br/></li>
                                        <li class="input-class"><input type="text" placeholder="To number..."

                                                                       class="form-control input-sm"/><br/></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Pediatrician</a>
                                    <ul>
                                        <li>
                                            <span>Number of Visits:</span>
                                        </li>
                                        <li class="input-class"><input type="text" placeholder="From number..."

                                                                       class="form-control input-sm"/><br/></li>
                                        <li class="input-class"><input type="text" placeholder="To number..."

                                                                       class="form-control input-sm"/><br/></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Dentist</a>
                                    <ul>
                                        <li>
                                            <span>Number of Visits:</span>
                                        </li>
                                        <li class="input-class"><input type="text" placeholder="From number..."

                                                                       class="form-control input-sm"/><br/></li>
                                        <li class="input-class"><input type="text" placeholder="To number..."

                                                                       class="form-control input-sm"/><br/></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">Others</a>
                                    <ul>
                                        <li>
                                            <span>Number of Visits:</span>
                                        </li>
                                        <li class="input-class"><input type="text" placeholder="From number..."

                                                                       class="form-control input-sm"/><br/></li>
                                        <li class="input-class"><input type="text" placeholder="To number..."

                                                                       class="form-control input-sm"/><br/></li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </li>
                <li>
                    <a href="#">Inpateint</a>
                    <ul>
                        <li>
                            <a href="#">Hospitalization</a>
                            <ul>
                                <li>
                                    <a href="#">Were hospitalized</a>
                                    <ul>
                                        <li class="input-class">
                                            <br/>
                                            <select id="hospitalizationStatus" name="hospitalizationStatus" class="form-control input-sm">
                                                <option value="yes">Yes</option>
                                                <option value="no">No</option>
                                                <option selected value="*">Not Important</option>
                                            </select>
                                        </li>
                                    </ul>
                                </li>
                                <li id="no-of-hospitalization" style="display: none;">
                                    <a href="#">Number of Hospitalization</a>
                                    <ul>
                                        <li class="input-class"><br/><input type="text" id="noOfHospFrom" placeholder="From number..."

                                                                            class="form-control input-sm"/><br/></li>
                                        <li class="input-class"><input type="text" id="noOfHospTo" placeholder="To number..."

                                                                       class="form-control input-sm"/><br/></li>
                                    </ul>
                                </li>
                                <li id="length-of-stay" style="display: none;">
                                    <a href="#">Length of Stay</a>
                                    <ul>
                                        <li class="input-class"><br/><input type="text" id="lengthOfStayFrom" placeholder="From duration..."

                                                                            class="form-control input-sm"/><br/></li>
                                        <li class="input-class"><input type="text" id="lengthOfStayTo" placeholder="To duration..."

                                                                       class="form-control input-sm"/><br/></li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </li>
            </ul>
        </li>
        <li>
            <h3><a href="#"><img src="../images/mortality.png" width="20px"/>Mortality</a></h3>
            <ul>
                <br/>
                <select id="mortality" class="form-control input-sm">
                    <option value="*">Not important</option>
                    <option value="1">Yes</option>
                    <option value="0">No</option>
                </select>
                <br/>
            </ul>
        </li>
        <li>
            <h3><a href="#"><img src="../images/comorbidities.png" width="20px"/>Comorbidities</a></h3>
            <ul>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector functional"
                       href="javascript:void(0);" comorbidity="bloodpressure"
                       onclick="handleActivation(this);"><img
                        src="../images/unchecked.png" width="16px"/> Ischemic Heart Disease</a></li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector functional"
                       href="javascript:void(0);" comorbidity="nausia"
                       onclick="handleActivation(this);"><img
                        src="../images/unchecked.png" width="16px"/> Heart Failure</a></li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector functional"
                       href="javascript:void(0);" comorbidity="dizziness"
                       onclick="handleActivation(this);"><img
                        src="../images/unchecked.png" width="16px"/> Acute Myocardial Infarction</a>
                </li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector functional"
                       href="javascript:void(0);" comorbidity="seizure"
                       onclick="handleActivation(this);"><img
                        src="../images/unchecked.png" width="16px"/> Hypertension</a></li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector non-functional"
                       disabled href="javascript:void(0);" comorbidity=""
                       onclick="void(0);">CVD</a></li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector non-functional"
                       disabled href="javascript:void(0);" comorbidity=""
                       onclick="void(0);">End stage renal disease</a></li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector non-functional"
                       disabled href="javascript:void(0);" comorbidity=""
                       onclick="void(0);">Renal Failure</a></li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector non-functional"
                       disabled href="javascript:void(0);" comorbidity=""
                       onclick="void(0);">Amputation</a></li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector non-functional"
                       disabled href="javascript:void(0);" comorbidity=""
                       onclick="void(0);">Obstructive pulmonary disease</a></li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector non-functional"
                       disabled href="javascript:void(0);" comorbidity=""
                       onclick="void(0);">Asthma</a></li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector non-functional"
                       disabled href="javascript:void(0);" comorbidity=""
                       onclick="void(0);">Mental illness</a></li>
                <li><a style="text-decoration: none;"
                       class="comorbidity-selector non-functional"
                       disabled href="javascript:void(0);" comorbidity=""
                       onclick="void(0);">Mood and anxiety disorder</a></li>
            </ul>
        </li>
        <li>
            <h3><a href="#"><img src="../images/indicator.png" width="20px"/>Health Indicator</a></h3>
            <ul>
                <br/>
                <select id="health-indicator" class="form-control input-sm">
                    <option value="count">Count</option>
                    <option value="prevalence">Prevalence</option>
                    <option value="incidence">Incidence</option>
                    <option value="rate">Rate</option>
                    <option value="cost">Cost</option>
                </select>
                <br/>
            </ul>
        </li>
        <li>
            <h3><a href="#"><img src="../images/geography.png" width="20px"/>Level of Geography</a></h3>
            <ul>
                <br/>
                <select id="geography-level" class="form-control input-sm">
                    <option selected value="fsa">Forward Sortation Area</option>
                    <option disabled value="fsa">Census Subdivision</option>
                    <option disabled value="fsa">Dissemination Area</option>
                    <option disabled value="fsa">Health Region</option>
                    <option disabled value="fsa">Local Area</option>
                    <!--<option selected value="CSD_UID">Census Subdivision</option>
                    <option value="DA_UID_11">Dissemination Area</option>
                    <option value="HA_ID">Health Region</option>
                    <option value="LA_ID">Local Area</option>-->
                </select>
                <br/>
            </ul>
        </li>
    </ul>
</div>
<script type="text/javascript">
    $('#hospitalizationStatus').on('change', function() {
        if( this.value == "yes"){
            $("#no-of-hospitalization").show();
            $("#length-of-stay").show();
        }else{
            $("#no-of-hospitalization").hide();
            $("#length-of-stay").hide();
        }
    });
</script>