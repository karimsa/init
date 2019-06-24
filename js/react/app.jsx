/**
 * @file src/app.jsx
 * @copyright 2019-present Karim Alibhai. All rights reserved.
 */

import React from 'react'
import ReactDOM from 'react-dom'
import { BrowserRouter, Switch, Route } from 'react-router-dom'

import { Home } from './views/home'

ReactDOM.render(
	<BrowserRouter>
		<Switch>
			<Route component={Home} />
		</Switch>
	</BrowserRouter>,
	document.getElementById('app'),
)
