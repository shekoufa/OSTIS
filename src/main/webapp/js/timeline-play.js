function togglePlay(){
    var timelineEndYear = 2015;
    if($("#play-status").hasClass("fa-play-circle")){
        //start the playback, change shape to pause
        $("#play-status").removeClass("fa-play-circle");
        $("#play-status").addClass("fa-pause-circle");
        theInterval = setInterval(function(){
            if (timelineStartYear > timelineEndYear){
                timelineStartYear = 1995;
            }else{
                prepareSendRequest(timelineStartYear);
                timelineStartYear++;
            }
        }, 8000);
    }else{
        //stop the playback, change shape to play
        clearInterval(theInterval);
        $("#play-status").removeClass("fa-pause-circle");
        $("#play-status").addClass("fa-play-circle");
    }
}