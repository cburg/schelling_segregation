
The primary purpose of this is two fold:
    1.) To explore building applications with QML
    2.) To explore Schellings segregation model

The application started out as a clone of the web implementation here:

    http://nifty.stanford.edu/2014/mccown-schelling-model-segregation/

It was interesting to see a real world comparison between a browser based
app and a QML based app. Both use (currently) JavaScript as the backend. In
my experience, my un-optimized QML app runs considerably faster than the 
Stanford app.

Additionally, the Stanford app has at least one bug: the number of empty 
tiles is not consistent between board resets with each parameter identical.
On a 30 x 30 grid, with 1% of cells empty, I have seen the number of empty 
cells range from 4 to 14.

But I nitpick. It's primarily used as an example and wasn't intended to be
a perfect implementation.



