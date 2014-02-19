function install (aEvent)
{
  var xpiparams = { "Turkopticon": { URL: aEvent.target.href,
             IconURL: aEvent.target.getAttribute("iconURL"), 
             Hash: aEvent.target.getAttribute("hash"),
             toString: function () { return this.URL; }
    }
  };
  InstallTrigger.install(xpiparams);
  return false;
}
