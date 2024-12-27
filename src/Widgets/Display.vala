/**
 * SPDX-FileCopyrightText: Copyright © 2020-2024 Louis Brauer <louis@brauer.family>
 * SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file Display.vala
 *
 * @brief Defines the below-headerbar display of stations in the Tuner application.
 *
 * This file contains the Display class, which implements various
 * features such as a source list, content stack that display and manage Station
 * settings and handles user actions like station selection.
 *
 * @see Tuner.Application
 * @see Tuner.DirectoryController
 */


using Gee;
using Granite.Widgets;


/**
 * @brief Display class for managing organization and presentation of genres and thier stations
 *
 * Display should be initialized and re-initialized by its owning class
 */
public class Tuner.Display : Gtk.Paned {

    private const string BACKGROUND_TUNER = "/io/github/louis77/tuner/icons/background-tuner";
    private const string BACKGROUND_JUKEBOX = "/io/github/louis77/tuner/icons/background-jukebox";
    private const int EXPLORE_CATEGORIES = 5;    // How many explore categories to display 
    private const double BACKGROUND_OPACITY = 0.15;    
    private const int BACKGROUND_TRANSITION_TIME_MS = 1500;    
    private const Gtk.RevealerTransitionType BACKGROUND_TRANSITION_TYPE = Gtk.RevealerTransitionType.CROSSFADE;


    /**
     * @brief Signal emitted when a station is clicked.
     * @param station The clicked station.
     */
    public signal void station_clicked_sig (Model.Station station);

    /**
     * @brief Signal emitted when the favourites list changes.
     */
    public signal void favourites_changed_sig ();

    /**
     * @brief Signal emitted to refresh starred stations.
     */
    public signal void refresh_starred_stations_sig ();

    /**
     * @brief Signal emitted when a search is performed.
     * @param text The search text.
     */
    public signal void searched_for_sig(string text);

    /**
     * @brief Signal emitted when the search is focused.
     */
    public signal void search_focused_sig();


    /**
     * @property stack
     * @brief The stack widget for managing different views.
     */
    public Gtk.Stack stack { get; construct; }

    /**
     * @property source_list
     * @brief The source list widget for displaying categories.
     */
    public SourceList source_list { get; construct; }

    /**
     * @property directory
     * @brief The directory controller for managing station data.
     */
    public DirectoryController directory { get; construct; }

    /*
        Display Assets
    */

    private SourceList.ExpandableItem _selections_category = new SourceList.ExpandableItem (_("Selections"));
    private SourceList.ExpandableItem _library_category = new SourceList.ExpandableItem (_("Library"));
    private SourceList.ExpandableItem _saved_searches_category = new SourceList.ExpandableItem (_("Saved Searches"));
    private SourceList.ExpandableItem _explore_category = new SourceList.ExpandableItem (_("Explore")); 
    private SourceList.ExpandableItem _genres_category = new SourceList.ExpandableItem (_("Genres"));
    private SourceList.ExpandableItem _subgenres_category = new SourceList.ExpandableItem (_("Sub Genres"));
    private SourceList.ExpandableItem _eras_category = new SourceList.ExpandableItem (_("Eras"));
    private SourceList.ExpandableItem _talk_category = new SourceList.ExpandableItem (_("Talk, News, Sport"));


    private bool _first_activation = true;  // display has not been activated before
    private bool _active = false;  // display is active
    private bool _jukebox_mode = false;  // Jukebox mode
    private Gtk.Revealer _background_tuner = new Gtk.Revealer();  // Background image
    private Gtk.Revealer _background_jukebox = new Gtk.Revealer();  // Background image
    private Gtk.Overlay _overlay = new Gtk.Overlay ();
 


    /* --------------------------------------------------------
    
        Public Methods

       ---------------------------------------------------------- */

    /**
     * @brief Constructs a new Display instance.
     * @param directory The directory controller to use.
     */
    public Display(DirectoryController directory)
    {
        Object(
            directory : directory
        );
    } // Display


    /**
    * Updates the state of the display
    */
    public void update_state( bool activate)
    {
        if ( _active && !activate )
        /* Present Offline look */
        {
            _active = false;
            return;
        }

        if ( !_active && activate )
        // Move from not active to active
        {

            if (_first_activation)
            // One time set up - do post initialization
            {
                //  TBD
                _first_activation = false;
                initialize.begin();   // TODO -  Check logic
            }
            _active = true;
            show_all();   
        }
    } // update_state


    /**
     * @brief Loads search stations based on the provided text and updates the content box.
     *
     * Async since 1.5.5 so that UI is responsive during long searches
     * @param searchText The text to search for stations.
     * @param search_box The ContentBox to update with the search results.
     */
     private async void load_station_search_results(string searchText, SourceListBox search_box) {

        debug(@"Searching for: $(searchText)");       
        var station_set = _directory.load_search_stations(searchText, 100);
        debug(@"Search done");

        try {
            var stations = station_set.next_page();
            debug(@"Search Next done");
            if (stations == null || stations.size == 0) {
                search_box.show_nothing_found();
            } else {
                debug(@"Search found $(stations.size) stations");
                var _slist = new StationList.with_stations(stations);
                hookup(_slist);
                search_box.content = _slist;
                search_box.parameter = searchText;
            }
        } catch (SourceError e) {
            search_box.show_alert();
        }
    } // load_search_stations


    /* --------------------------------------------------------
    
        Private Methods

       ---------------------------------------------------------- */


    /* Construct */
    construct 
    { 
        var tuner = new Gtk.Image.from_resource (BACKGROUND_TUNER);
        tuner.opacity = BACKGROUND_OPACITY;
        _background_tuner.transition_duration = BACKGROUND_TRANSITION_TIME_MS;
        _background_tuner.transition_type = BACKGROUND_TRANSITION_TYPE;   
        _background_tuner.reveal_child = true; 
        _background_tuner.child = tuner;

        var jukebox = new Gtk.Image.from_resource (BACKGROUND_JUKEBOX);    
        jukebox.opacity = BACKGROUND_OPACITY;
        _background_jukebox.transition_duration = BACKGROUND_TRANSITION_TIME_MS;
        _background_jukebox.transition_type = BACKGROUND_TRANSITION_TYPE;
        _background_jukebox.reveal_child = false;
        _background_jukebox.child = jukebox;

        var background = new Gtk.Fixed();
        background.add(_background_tuner);
        background.add(_background_jukebox);
        background.halign = Gtk.Align.CENTER;
        background.valign = Gtk.Align.CENTER;
        _overlay.add (background);

        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.CROSSFADE;
        _overlay.add_overlay(stack);

        // ---------------------------------------------------------------------------

        // Set up the LHS directory structure

        _selections_category.collapsible = false;
        _selections_category.expanded = true;

        _library_category.collapsible = false;
        _library_category.expanded = false;

        _saved_searches_category.collapsible = true;
        _saved_searches_category.expanded = false;

        _explore_category.collapsible = true;
        _explore_category.expanded = false;

        _genres_category.collapsible = true;
        _genres_category.expanded = false;

        _subgenres_category.collapsible = true;
        _subgenres_category.expanded = false;

        _eras_category.collapsible = true;
        _eras_category.expanded = false;

        _talk_category.collapsible = true;
        _talk_category.expanded = false;

        source_list = new SourceList();
        
        source_list.root.add (_selections_category);
        source_list.root.add (_library_category);
        source_list.root.add (_explore_category);
        source_list.root.add (_genres_category);
        source_list.root.add (_subgenres_category);
        source_list.root.add (_eras_category);
        source_list.root.add (_talk_category);

        source_list.ellipsize_mode = Pango.EllipsizeMode.NONE;
        source_list.item_selected.connect  ((item) => 
        // Syncs Item choice to Stack view
        {
            var selected_item = item.get_data<string> ("stack_child");
            stack.visible_child_name = selected_item;
        });

        // ---------------------------------------------------------------------------

        pack1 (source_list, false, false);
        pack2 (_overlay, true, false);
                    
    } // construct


    /* --------------------------------------------------------
    
        Methods

        ----------------------------------------------------------
    */


    /**
     * @brief Initializes the main Display object
     */
    private async void initialize()
    {
        _directory.load (); // Initialize the DirectoryController

        /* Initialize the directory contents */

        /* ---------------------------------------------------------------------------
            Discover
        */

        var discover = SourceListBox.create ( stack
            , source_list
            ,  _selections_category
            , "discover"
            , "face-smile"
            , "Discover"
            , "Stations to Explore"
            ,_directory.load_random_stations(20)
            , "Discover more stations"
            , "media-playlist-shuffle-symbolic");
            
        discover.realize.connect (() => {
            populate(discover);
        });
        
        discover.action_button_activated_sig.connect (() => {
            populate(discover);
        });


        /* ---------------------------------------------------------------------------
            Trending
        */
        create_category_specific
            ( stack
                , source_list
                , _selections_category
                , "trending"
                , "playlist-queue"
                , "Trending"
                , "Trending in the last 24 hours"
                ,_directory.load_trending_stations(40) 
            );

        /* ---------------------------------------------------------------------------
            Popular
        */

        create_category_specific
            ( stack
                , source_list
                , _selections_category
                , "popular"
                , "playlist-similar"
                , "Popular"
                , "Most-listened over 24 hours"
                ,_directory.load_popular_stations(40)
            );
    

        // ---------------------------------------------------------------------------

        jukebox(_selections_category);

        // ---------------------------------------------------------------------------
        // Country-specific stations list
        
        //  var item4 = new Granite.Widgets.SourceList.Item (_("Your Country"));
        //  item4.icon = new ThemedIcon ("emblem-web");
        //  ContentBox c_country;
        //  c_country = create_content_box ("my-country", item4,
        //                      _("Your Country"), null, null,
        //                      stack, source_list, true);
        //  var c_slist = new StationList ();
        //  c_slist.selection_changed.connect (handle_station_click);
        //  c_slist.favourites_changed.connect (handle_favourites_changed);

        // ---------------------------------------------------------------------------

        /* ---------------------------------------------------------------------------
            Starred
        */

        var starred = create_category_predefined
            (   stack
                , source_list
                , _library_category
                , "starred"
                , "starred"
                , _("Starred by You")
                , _("Starred by You")
                ,_directory.get_starred() 
            );

            starred.badge ( @"$(starred.item_count)\t");
            starred.notify["item-count"].connect (()=> {
                starred.badge ( @"$(starred.item_count)\t");
            });


        // ---------------------------------------------------------------------------
        // Search Results Box
        

        var search_results = SourceListBox.create 
        ( stack
        , source_list
        , _library_category
        , "searched"
        , "folder-saved-search"
        , _("Recent Search")
        , _("Search Results")
        , null
        , _("Save this search")
        , "starred-symbolic");

        search_results.tooltip_button.sensitive = false;

        // Add saved search from star press
        search_results.action_button_activated_sig.connect (() => {
            if ( app().is_offline ) return;                 
            search_results.tooltip_button.sensitive = false;    
            var new_saved_search  = add_saved_search( search_results.parameter, _directory.add_saved_search (search_results.parameter));
            new_saved_search.list(search_results.content);
            populate(new_saved_search);
            source_list.selected = source_list.get_last_child (_saved_searches_category);
        });

        // ---------------------------------------------------------------------------
        // Saved Searches


        // Add saved searches to category from Directory
        var saved_searches = _directory.load_saved_searches();
        foreach( var search_term in saved_searches.keys)
        {
           add_saved_search( search_term, saved_searches.get (search_term));
        }
        _saved_searches_category.icon = new ThemedIcon ("library-music");
        _library_category.add (_saved_searches_category);   // Added as last item of library category

        // ---------------------------------------------------------------------------

        // Explore Categories category
        // Get random categories and stations in them
        if ( app().is_online)
        {
            uint explore = 0;
            foreach (var tag in _directory.load_random_genres(EXPLORE_CATEGORIES))
            {
            if ( Model.Genre.in_genre (tag.name)) break;  // Predefined genre, ignore
                create_category_specific( stack, source_list, _explore_category
                    , @"$(explore++)"   // tag names can have charaters that are not suitable for name
                    , "playlist-symbolic"
                    , tag.name
                    , tag.name
                    , _directory.load_by_tag (tag.name));
            }
        }

        // ---------------------------------------------------------------------------

        // Genre Boxes
        create_category_genre( stack, source_list, _genres_category, _directory,   Model.Genre.GENRES );

        // Sub Genre Boxes
        create_category_genre( stack, source_list, _subgenres_category, _directory,   Model.Genre.SUBGENRES );

        // Eras Boxes
        create_category_genre( stack, source_list, _eras_category,   _directory, Model.Genre.ERAS );
    
        // Talk Boxes
        create_category_genre( stack, source_list, _talk_category, _directory,   Model.Genre.TALK );
    
        // --------------------------------------------------------------------


        refresh_starred_stations_sig.connect ( () => 
        //
        {
            if ( app().is_offline ) return;
            var _slist = new StationList.with_stations (_directory.get_starred ());
            hookup(_slist);
            starred.content = _slist;
        });


        search_focused_sig.connect (() => 
        // Show searched stack when cursor hits search text area
        {
            stack.visible_child_name = "searched";
        });


        searched_for_sig.connect ( (text) => 
        // process the searched text, stripping it, and sensitizing the save 
        // search star depending on if the search is already saved
        {
            var search = text.strip ();
            if ( search.length > 0 ) {
                load_station_search_results.begin(search, search_results);
                if ( stack.get_child_by_name (search) == null )  // Search names are prefixed with >
                {
                    search_results.tooltip_button.sensitive = true;
                    return;
                }
            }
            else
            {
                search_results.show_nothing_found ();
            }
            search_results.tooltip_button.sensitive = false;
        });
    } // initialize


    /**
     */
    public void choose_star()
    {
        source_list.selected = source_list.get_first_child (_library_category);
    } // choose_star

    /* -------------------------------------------------

        Helpers

        Shortcuts to configure the source_list and stack

       -------------------------------------------------
    */

    /**
     * @brief Configures the jukebox mode for a category.
     * @param category The category to configure.
     */
    private void jukebox(SourceList.ExpandableItem category)
    {
        SourceList.Item item = new SourceList.Item(_("Jukebox"));
        //  item.icon = new ThemedIcon("audio-speakers");
        item.icon = new ThemedIcon("jukebox");
        var station = _directory.load_random_stations(1);
        item.activated.connect(() =>
        {
            try {
                station_clicked_sig(station.next_page().to_array()[0]);
                _jukebox_mode = true;
                _background_tuner.reveal_child = false;    
                _background_jukebox.reveal_child = true; 
            } 
            catch (SourceError e)
            {
                warning(_(@"Could not get random station: $(e.message)"));
            }
        });

        app().player.tape_counter_sig.connect((oldstation) =>
        {     
            try {
                if ( _jukebox_mode ) station_clicked_sig(station.next_page().to_array()[0]);
            } 
            catch (SourceError e)
            {
                warning(_(@"Could not get random station: $(e.message)"));
            }
        });
        category.add(item);
    } // jukebox


    /**
     * @brief Hooks up signals for a StationList.
     * @param slist The StationList to hook up.
     */
    private void hookup(StationList slist)
    {
        slist.station_clicked_sig.connect((station) =>
        {
            station_clicked_sig(station);
            _jukebox_mode = false;                     
            _background_jukebox.reveal_child = false;
            _background_tuner.reveal_child = true;      
        });

        slist.favourites_changed_sig.connect(() =>
        {
            refresh_starred_stations_sig();
        });
    } // hookup


    /** */
    private SourceListBox add_saved_search(string search, StationSet station_set, StationList? content = null)//StationSet station_set)
    {
        var saved_search = create_category_specific 
            ( stack
            , source_list
            , _saved_searches_category
            , search
            , "playlist-symbolic"
            , search
            , _(@"Saved Search :  $search")
            , station_set
            , _("Remove this saved search")
            , "non-starred-symbolic"
            );

        if ( content != null ) { 
            saved_search.content = content; 
        }

        saved_search.action_button_activated_sig.connect (() => {
            if ( app().is_offline ) return;
            _directory.remove_saved_search (search);
            saved_search.delist ();
        });

        return saved_search;
    } // refresh_saved_searches
    

    /**
     * @brief Creates a predefined category in the source list.
     * @param stack The stack widget.
     * @param source_list The source list widget.
     * @param category The category to add to.
     * @param name The name of the category.
     * @param icon The icon for the category.
     * @param title The title of the category.
     * @param subtitle The subtitle of the category.
     * @param stations The collection of stations for the category.
     * @return The created SourceListBox for the category.
     */
    private SourceListBox create_category_predefined
        ( Gtk.Stack stack
        , Granite.Widgets.SourceList source_list
        , Granite.Widgets.SourceList.ExpandableItem category
        , string name
        , string icon
        , string title
        , string subtitle
        , Collection<Model.Station>? stations
        )
    {
        var genre = SourceListBox.create 
            ( stack
            , source_list
            , category
            , name
            , icon
            , title
            , subtitle 
            );

        if (stations != null)
        {    
            var slist = new StationList.with_stations (stations);
            hookup(slist);
            genre.content = slist;
        }

        return genre;
    
    } // create_category_predefined


    /**
     * @brief Creates a specific category in the source list.
     * @param stack The stack widget.
     * @param source_list The source list widget.
     * @param category The category to add to.
     * @param name The name of the category.
     * @param icon The icon for the category.
     * @param title The title of the category.
     * @param subtitle The subtitle of the category.
     * @param station_set The set of stations for the category.
     * @param action_tooltip_text Optional tooltip text for the action.
     * @param action_icon_name Optional icon name for the action.
     * @return The created SourceListBox for the category.
     */
    private SourceListBox create_category_specific 
        ( Gtk.Stack stack
        , Granite.Widgets.SourceList source_list
        , Granite.Widgets.SourceList.ExpandableItem category
        , string name
        , string icon
        , string title
        , string subtitle
        , StationSet station_set
        , string? action_tooltip_text = null
        , string? action_icon_name = null
        )
    {
        var genre = SourceListBox.create 
            ( stack
            , source_list
            , category
            , name
            , icon
            , title
            , subtitle 
            , station_set
            , action_tooltip_text
            , action_icon_name
            );

        genre.realize.connect (() => {
            populate(genre);
        });        
        return genre;
    } // create_category_specific


    /**
     * @brief Populates a SourceListBox with stations.
     * @param slb The SourceListBox to populate.
     */
    private void populate(SourceListBox slb )
    {
        if ( app().is_offline ) return;
        try {
            var slist = new StationList.with_stations (slb.next_page ());
            hookup(slist);
            slb.content = slist;
        } catch (SourceError e) {
            slb.show_alert ();
        }
    }
    

    /**
     * @brief Creates genre-specific categories in the source list.
     * @param stack The stack widget.
     * @param source_list The source list widget.
     * @param category The category to add to.
     * @param directory The directory controller.
     * @param genres The array of genres.
     */
    private void create_category_genre
        ( Gtk.Stack stack
        , Granite.Widgets.SourceList source_list
        , Granite.Widgets.SourceList.ExpandableItem category
        , DirectoryController directory
        , string[] genres
        )
    {
        foreach (var genre in genres ) {
            create_category_specific(stack
                , source_list
                , category
                , genre
                , "playlist-symbolic"
                , genre
                , genre
                , directory.load_by_tag (genre.down ()));
        }
    } // create_category_genre
} // Display
