function Controller() {
	/* maybe needed. just leave it here for later
    installer.autoRejectMessageBoxes();
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    })*/
	
	// workaround from here: https://bugreports.qt.io/browse/QTIFW-1072
	var page = gui.pageWidgetByObjectName("WelcomePage")
    page.completeChanged.connect(welcomepageFinished)
	var page2 = gui.pageWidgetByObjectName("PerformInstallationPage")
    page2.completeChanged.connect(PerformInstallationFinished)
}

welcomepageFinished = function() {
    if(gui.currentPageWidget().objectName == "WelcomePage") {
		gui.clickButton(buttons.NextButton);   
    }
}

PerformInstallationFinished = function() {
    if(gui.currentPageWidget().objectName == "PerformInstallationPage") {
		gui.clickButton(buttons.NextButton);   
		//gui.clickButton(buttons.CommitButton);   
    }
}

function log() {
	console.log(["QTCI: "].concat([].slice.call(arguments)).join(" "))
}

/* broken in installer 3.0.2
Controller.prototype.WelcomePageCallback = function() {
    gui.clickButton(buttons.NextButton);
}*/

Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();

    widget.deselectAll();
    widget.selectComponent("qt.qt5.5100.win64_msvc2017_64");
    widget.selectComponent("qt.qt5.5100.qtwebengine");
    widget.selectComponent("qt.qt5.5100.qtscript");

	var components = installer.components();
    log("Available components: " + components.length);
    for (var i = 0 ; i < components.length ;i++) {
        log(" " + components[i].name);
    }
	gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.PerformInstallationPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}	

Controller.prototype.FinishedPageCallback = function() {
	var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm
	if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
		checkBoxForm.launchQtCreatorCheckBox.checked = false;
	}
	gui.clickButton(buttons.FinishButton);
}