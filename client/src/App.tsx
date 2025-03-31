import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import './App.css';
import '@salesforce-ux/design-system/assets/styles/salesforce-lightning-design-system.min.css';

// Import future components
// import Header from './components/Header';
// import Sidebar from './components/Sidebar';
// import Dashboard from './components/Dashboard';
// import AutomationList from './components/AutomationList';
// import LogAnalyzer from './components/LogAnalyzer';

function App() {
  return (
    <Router>
      <div className="App slds-grid slds-grid_vertical">
        <header className="slds-global-header_container">
          <div className="slds-global-header slds-grid slds-grid_align-spread">
            <div className="slds-global-header__item">
              <h1 className="slds-text-heading_medium">SFxLens</h1>
            </div>
          </div>
        </header>

        <div className="slds-grid slds-grid_vertical-stretch">
          <div className="slds-col slds-size_1-of-4 slds-p-around_medium">
            {/* Sidebar will go here */}
            <nav className="slds-nav-vertical">
              <div className="slds-nav-vertical__section">
                <h2 className="slds-nav-vertical__title">Navigation</h2>
                <ul>
                  <li className="slds-nav-vertical__item">
                    <a href="/" className="slds-nav-vertical__action">Dashboard</a>
                  </li>
                  <li className="slds-nav-vertical__item">
                    <a href="/flows" className="slds-nav-vertical__action">Flows</a>
                  </li>
                  <li className="slds-nav-vertical__item">
                    <a href="/apex" className="slds-nav-vertical__action">Apex</a>
                  </li>
                  <li className="slds-nav-vertical__item">
                    <a href="/logs" className="slds-nav-vertical__action">Logs</a>
                  </li>
                </ul>
              </div>
            </nav>
          </div>

          <div className="slds-col slds-size_3-of-4 slds-p-around_medium">
            <Routes>
              <Route path="/" element={<div>Dashboard Coming Soon</div>} />
              <Route path="/flows" element={<div>Flows Coming Soon</div>} />
              <Route path="/apex" element={<div>Apex Coming Soon</div>} />
              <Route path="/logs" element={<div>Logs Coming Soon</div>} />
            </Routes>
          </div>
        </div>
      </div>
    </Router>
  );
}

export default App;
