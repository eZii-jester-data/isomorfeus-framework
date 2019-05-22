import * as Redux from 'redux';
import React from 'react';
import ReactDOM from 'react-dom';
// import * as History from 'history';
import * as ReactRouter from 'react-router';
import * as ReactRouterDOM from 'react-router-dom';
import { BrowserRouter, Link, NavLink, Route, Switch } from 'react-router-dom';


global.Redux = Redux;
global.React = React;
global.ReactDOM = ReactDOM;
// global.History = History;
global.ReactRouter = ReactRouter;
global.ReactRouterDOM = ReactRouterDOM;
global.BrowserRouter = BrowserRouter;
global.Link = Link;
global.NavLink = NavLink;
global.Route = Route;
global.Switch = Switch;


if (module.hot) { module.hot.accept(); }
