<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Master/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">



    <style>

        body{
            background-color:black;
        }


        .vertical .carousel-inner {
            height: 100%;
        }

        .carousel.vertical .item {
            -webkit-transition: 0.6s ease-in-out top  ;
            -moz-transition: 0.6s ease-in-out top  ;
            -ms-transition: 0.6s ease-in-out top  ;
            -o-transition: 0.6s ease-in-out top  ;
            transition: 0.6s ease-in-out top ;
             left: 0;
        }
      

        .carousel.vertical .active {
            top: 0;
           
        }

        .carousel.vertical .next {
            top: 100%;
      
        }

        .carousel.vertical .prev {
            top: -100%;
       
        }

            .carousel.vertical .next.left,
            .carousel.vertical .prev.right {
                top: 0;
            }

        .carousel.vertical .active.left {
            top: -100%;

        }

        .carousel.vertical .active.right {
            top: 100%;
            
        }

        
    </style>



    <div id="myCarousel" class="carousel slide vertical" data-ride="carousel" style="overflow: hidden">
        <!-- Indicators -->
        <ol class="carousel-indicators">
            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
            <li data-target="#myCarousel" data-slide-to="1"></li>
            <li data-target="#myCarousel" data-slide-to="2"></li>
        </ol>
        <!-- Wrapper for slides -->
        <div class="carousel-inner">
            <div class="item active">
                <img src="images/maserati.jpg" alt="" style="width: 100%;">
            </div>
            <!--
            <div class="item">
                <img src="Images/la.jpg" alt="" style="width: 100%;">
            </div>

            <div class="item">
                <img src="Images/ny.jpg" alt="" style="width: 100%;">
            </div> -->
        </div>

        <!-- Left and right controls -->
        <a class="left carousel-control" data-target="#myCarousel" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="right carousel-control" data-target="#myCarousel" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>
</asp:Content>
